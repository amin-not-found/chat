package dto

import "github.com/gorilla/websocket"

type ConnectionDto struct {
	Conn   *websocket.Conn
	IsOpen bool
}
