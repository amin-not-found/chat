package dto

import "time"

type ClientMessage struct {
	// type isn't required bc if it isn't a valid value we can just ignore it, at least for now
	Type    string
	Content string `validate:"required"`
	Sender  string `validate:"required"`
}

type Message struct {
	// Warning: id might change in future
	Id      int
	Type    string
	Sender  string
	Content string
	Time    time.Time
}

type StatusMessage struct {
	Success bool
}
