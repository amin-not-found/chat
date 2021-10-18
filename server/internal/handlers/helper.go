package handlers

import (
	"encoding/json"
	"net/http"
)

type Info struct {
	Title       string
	Description string
}

func InfoResponse(title string, description string) Info {
	return Info{
		Title:       title,
		Description: description,
	}
}

func (info Info) Inform(w http.ResponseWriter, status int) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	json.NewEncoder(w).Encode(info)
}
