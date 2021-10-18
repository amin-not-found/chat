package handlers

import (
	"net/http"
)

func TestHandler(w http.ResponseWriter, r *http.Request) {
	InfoResponse("Ok", "Server seems to be running well").Inform(w, http.StatusOK)
}
