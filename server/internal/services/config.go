package services

import (
	"os"
	"time"
)

const (
	defualtPort = "8080"
	//defaultHost = "192.168.1.5"
	defaultHost = ""
)

type Configuration struct {
	ServerPort           string
	ServerHost           string
	AuthSecret           []byte
	AccessTokenDuration  time.Duration
	RefreshTokenDuration time.Duration
}

func GetConfig() Configuration {
	config := Configuration{
		ServerPort: defualtPort,
		ServerHost: defaultHost,
		AuthSecret: []byte("CcK^IW!2slFsKULM"),
		// user doesn't need a lot of time for authentication and the token is usually needed once just for websocket
		AccessTokenDuration:  time.Minute * 5,
		RefreshTokenDuration: time.Hour * 24 * 7, // 7 days

	}

	port := os.Getenv("PORT")

	if port != "" {
		config.ServerPort = port
	}
	return config
}
