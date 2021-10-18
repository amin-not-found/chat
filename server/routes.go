package main

import (
	"net/http"
	"server/internal/handlers"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
)

func GetRoutes() *chi.Mux {
	r := chi.NewRouter()

	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)

	r.Get("/", handlers.TestHandler)
	r.Get("/authtest", handlers.Authorize(http.HandlerFunc(handlers.TestHandler)))
	r.Get("/ws", handlers.WebsocketHandler)

	r.Post("/signup", handlers.SignUp)
	r.Post("/signin", handlers.SignIn)
	r.Post("/refresh", handlers.Refresh)

	return r
}
