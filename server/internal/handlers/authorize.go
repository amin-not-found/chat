package handlers

import (
	"context"
	"fmt"
	"net/http"
	"server/internal/services/users"
	"strings"
)

func Authorize(next http.Handler) http.HandlerFunc {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		authHeader := strings.Split(r.Header.Get("Authorization"), "Bearer ")
		if len(authHeader) != 2 {
			InfoResponse("Something went wrong", "Couldn't log in").Inform(w, http.StatusUnauthorized)
		} else {
			jwtToken := authHeader[1]

			claims, err := users.VerifyToken(jwtToken)

			if err != nil {
				fmt.Println(err)
				InfoResponse("Couln't login", "Something is wrong").Inform(w, http.StatusUnauthorized)
			} else {
				ctx := context.WithValue(r.Context(), "props", claims)
				next.ServeHTTP(w, r.WithContext(ctx))
			}
		}
	})
}
