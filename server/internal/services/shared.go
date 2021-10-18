package services

import (
	"server/ent"

	_ "github.com/mattn/go-sqlite3"
)

var EntClient *ent.Client
var Config Configuration

func SetSharedData(entClient *ent.Client, config Configuration) {
	EntClient = entClient
	Config = config
}
