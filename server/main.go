package main

import (
	"log"
	"net/http"

	"server/internal/services"
	"server/internal/services/chat"
)

func main() {
	var err error

	config := services.GetConfig()

	entClient := services.InitEnt()
	defer entClient.Close()
	services.SetSharedData(entClient, config)

	go chat.ReceiveMessages()

	address := config.ServerHost + ":" + config.ServerPort
	log.Printf("Server is running on %s...", address)

	r := GetRoutes()

	err = http.ListenAndServe(address, r)
	if err != nil {
		log.Panic(err)
	}
}
