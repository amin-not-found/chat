package chat

import (
	"context"
	"log"
	"server/ent"
	"server/pkg/dto"
	"strconv"
	"time"
)

// TODO : find a better name for this file

func enitytyToMsgObj(msgEntity *ent.Message, ctx context.Context) dto.Message {
	// TODO : handle error
	sender, _ := msgEntity.QuerySender().Only(ctx)
	// TODO : format message to TextMessage??
	return dto.Message{
		Id:   msgEntity.ID,
		Type: msgEntity.Type,
		// TODO set string method for user
		Sender:  sender.Username,
		Content: msgEntity.Content,
		Time:    msgEntity.Time,
	}
}

func sendMessage(ctx context.Context, conn dto.ConnectionDto, receiver *ent.User, msg dto.Message) error {
	err := conn.Conn.WriteJSON(msg)
	if err != nil && unsafeError(err) {
		log.Printf("error: %v", err)
		conn.Conn.Close()
		delete(clients, receiver.Username)
	}

	return err
}

func sendEntityMessage(ctx context.Context, conn dto.ConnectionDto, receiver *ent.User, msgEntity *ent.Message) {
	// TODO : maybe make a variable here to sent in the end and just change its value in switch
	// TODO : implement ACK to be sure message has been sent(delivery message type)
	msg := enitytyToMsgObj(msgEntity, ctx)
	sendMessage(ctx, conn, receiver, msg)

}

func sendDeliveryMessage(ctx context.Context, conn dto.ConnectionDto, receiver *ent.User, msgEntity *ent.Message) {
	msg := dto.Message{
		Id:      0,
		Type:    "server_delivery",
		Sender:  "",
		Content: strconv.FormatInt(msgEntity.LocalID, 10),
		Time:    time.Now(),
	}
	sendMessage(ctx, conn, receiver, msg)
}
