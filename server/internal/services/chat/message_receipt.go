package chat

import (
	"context"
	"fmt"
	"log"
	"server/ent"
	"server/ent/message"
	"server/ent/user"
	"server/internal/services"
	"server/pkg/dto"
	"strconv"
	"time"
)

type WaitingMessage struct {
	message   dto.ClientMessage
	receivers []string
}

func tryDeleteMessage(msgEntity *ent.Message, ctx context.Context) error {
	msg := msgEntity.Unwrap()
	// Don't continue if message delete isn't permitted or message isn't sent to all of its receivers
	if !msg.CanBeDeleted || !(len(msg.Edges.Receivers) != 0) {
		return nil
	}
	return services.EntClient.Message.DeleteOne(msg).Exec(ctx)
}

func ReceiveMessages() {
	for {
		// grab any message in form of Message from channel
		waitingMsg := <-broadcaster
		msg := waitingMsg.message
		ctx := context.Background()
		sender, err := services.EntClient.User.Query().Where(user.Username(msg.Sender)).Only(ctx)

		if err != nil {
			// TODO : Handle error
			log.Printf("Couldn't find user %s", msg.Sender)
			return
		}

		var msgEntity *ent.Message

		switch msg.Type {
		// We shoulwouldd send a delivery message everytime we get a message. This way client will send the
		// message until it gets the delivery message and stops sending the message to us. In certein cases
		// like client_delivery we should send a delivery message; So we will return from function in those cases
		case "text":
			msgEntity = handleTextMessage(waitingMsg, ctx, msg, sender)
		case "msg_del_permit":
			handleMsgDeletePermit(msg, ctx)
			return
			// Client should send a delivery message everytime it gets a message. This way the we would
			// send the message until we get the delivery message and stop sending the message to the client
		case "client_delivery":
			handleDeliveryMessage(msg, ctx, sender)
			return
		}

		if conn, ok := clients[sender.Username]; ok {
			sendDeliveryMessage(ctx, conn, sender, msgEntity)
		}

	}
}

func handleTextMessage(waitingMsg WaitingMessage, ctx context.Context, msg dto.ClientMessage, sender *ent.User) *ent.Message {
	var receivers []*ent.User

	for _, receiverUname := range waitingMsg.receivers {

		user, err := services.EntClient.User.Query().Where(user.Username(receiverUname)).Only(ctx)
		if err == nil {
			// TODO : handle the error
			receivers = append(receivers, user)
		}
	}
	msgEntity, err := services.EntClient.Message.Create().SetTime(time.Now()).SetType(msg.Type).SetSender(sender).SetContent(msg.Content).AddReceivers(receivers...).SetCanBeDeleted(false).Save(ctx)
	if err != nil {
		// TODO : handle the error
		log.Println("Couldn't save the message:")
		log.Println(err)
		return nil
	}

	for _, receiver := range receivers {
		fmt.Println(receiver.Username)
		ctx := context.Background()
		if conn, ok := clients[receiver.Username]; ok {
			sendEntityMessage(ctx, conn, receiver, msgEntity)
		}
	}

	return msgEntity
}

func handleDeliveryMessage(msg dto.ClientMessage, ctx context.Context, sender *ent.User) {
	id, err := strconv.Atoi(msg.Content)
	if err != nil {
		log.Print("Couldn't parse id of delivered message:")
		log.Println(msg)
		return
	}
	msgEntity, err := services.EntClient.Message.Query().Where(message.ID(id)).Only(ctx)

	if err != nil {
		// TODO : handle the error
		return
	}

	msgEntity.Update().RemoveReceivers(sender).Save(ctx)
	// TODO : use function return value
	tryDeleteMessage(msgEntity, ctx)
}

// Client will send a permission to delete the message on server when it has removed the message from the queue of unsent messages. This is to make
// sure message doesn't get deleted on server while client is still trying to send a message which can cause message to be sent multiple times
func handleMsgDeletePermit(del_permit_msg dto.ClientMessage, ctx context.Context) error {
	msg_id, err := strconv.Atoi(del_permit_msg.Content)
	if err != nil {
		log.Print("Couldn't parse id of delete-permited message:")
		log.Println(del_permit_msg)
		return nil
	}

	msgEntity, err := services.EntClient.Message.Query().Where(message.LocalID(int64(msg_id)),
		message.HasSenderWith(user.Username(del_permit_msg.Sender))).Only(ctx)
	if err != nil {
		// TODO : handle the error
		return err
	}

	msgEntity.Update().SetCanBeDeleted(true).Save(ctx)

	return tryDeleteMessage(msgEntity, ctx)
}
