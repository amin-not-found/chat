package handlers

import (
	"log"
	"net/http"

	"server/internal/services/chat"
	"server/internal/services/users"
	"server/pkg/dto"
)

func WebsocketHandler(w http.ResponseWriter, r *http.Request) {

	token := r.URL.Query().Get("token")

	claims, err := users.VerifyToken(token)

	if err != nil {
		// TODO : handle the error
		InfoResponse("Couldn't login to server", "Something went wrong while authorizing user").Inform(w, http.StatusUnauthorized)
		return
	}

	ws, err := chat.Upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Print("Error wile upgrading connection to WS:\n", err)
	}

	connDto := dto.ConnectionDto{
		Conn:   ws,
		IsOpen: true,
	}

	go chat.AddConnection(claims["Username"].(string), connDto)
}
