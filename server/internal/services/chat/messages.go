package chat

import (
	"encoding/json"
	"io"
	"log"
	"server/pkg/dto"
	"server/pkg/validator"

	"github.com/gorilla/websocket"
)

// TODO : move some of logic to another file to make this file smaller in number of lines

func AddConnection(username string, connDto dto.ConnectionDto) {
	// TODO TODO : delete this method of auth and use query before upgardeing in ws handler

	// ensure connection close when function returns
	defer connDto.Conn.Close()
	clients[username] = connDto

	for {
		// Read in a new message as JSON and map it to a Message object
		_, buffer, err := connDto.Conn.ReadMessage()
		if err != nil {
			delete(clients, username)
			// TODO : I'm nott sure if I should break now and what does this error mean. fix it
			break
		}

		var msg dto.ClientMessage
		if err := json.Unmarshal(buffer, &msg); err != nil {
			log.Printf("Couldn't unmarshal message: %s \nerr:", buffer)
			log.Println(err)
			continue
		}
		msg.Sender = username

		// at this point doing this seems to be a wrong thing bc i would rather validation logic to
		// be somewhere else and validating client message like this can be a bit over kill but server
		// isn't gonna be near complete and these are just a base for a more complete version of server
		// Make neede changes in future(read above comments)
		err = validator.Validate.Struct(msg)

		if err != nil {
			// TODO : better error handling
			log.Println("Invalid Message struct. error:")
			log.Println(err)
			continue
		}

		msg.Sender = username
		// send new message to the channel in form of Message obj(dto)
		broadcaster <- WaitingMessage{message: msg, receivers: getUsers()}

	}
}

// it is a temporary function to get all users
func getUsers() []string {
	users := make([]string, 0, len(clients))
	// This isn't an efficient code but this part is gonna change in future, when
	//server is a bit more developed. so i didn't bother to make it any better
	for client := range clients {
		users = append(users, client)
	}
	return users
}

func unsafeError(err error) bool {
	return !websocket.IsCloseError(err, websocket.CloseGoingAway) && err != io.EOF
}
