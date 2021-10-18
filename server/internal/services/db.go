package services

import (
	"context"
	"log"
	"server/ent"

	_ "github.com/mattn/go-sqlite3"
)

func InitEnt() *ent.Client {
	//client, err := ent.Open("sqlite3", "file:ent?mode=memory&cache=shared&_fk=1")
	// TODO : make part of config
	client, err := ent.Open("sqlite3", "file:ent.db?_fk=1")
	if err != nil {
		log.Fatalf("failed opening connection to sqlite: %v", err)
	}
	// Run the auto migration tool.
	if err := client.Schema.Create(context.Background()); err != nil {
		log.Fatalf("failed creating schema resources: %v", err)
	}
	return client
}
