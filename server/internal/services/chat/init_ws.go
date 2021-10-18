package chat

import (
	"net/http"
	"server/pkg/dto"
	"time"

	"github.com/gorilla/websocket"
)

// [conn]sender
var clients = make(map[string]dto.ConnectionDto)
var broadcaster = make(chan WaitingMessage)

var Upgrader = websocket.Upgrader{
	// TODO : set a reall origin checker
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
	HandshakeTimeout: time.Second * 9,
}

// it might be better to move this to another place in the future
// but for now it is meaningless bc it isn't actucally doing much
