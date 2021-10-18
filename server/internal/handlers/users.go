package handlers

import (
	"context"
	"encoding/json"
	"net/http"
	"server/internal/services/users"
	"server/pkg/dto"
	"server/pkg/validator"
)

// TODO : Refactor this code
// Moving some parts of logic to validator can be a nive idea

func SignUp(w http.ResponseWriter, r *http.Request) {
	var user dto.SignUpUser

	err := json.NewDecoder(r.Body).Decode(&user)
	// TODO: better error handling
	if err != nil {
		InfoResponse("Something went wrong", "Couldn't process user input").Inform(w, http.StatusUnsupportedMediaType)
		return
	}

	err = validator.Validate.Struct(user)

	if err != nil {
		// TODO : user friendly error
		InfoResponse("Invalid field nputs", err.Error()).Inform(w, http.StatusUnprocessableEntity)
		return
	}

	ctx := context.Background()
	errMsg, err := users.CreateUser(ctx, user.Username, user.Password, user.Name)

	if err != nil {
		// TODO : Error message isn't quite right
		// it should say "user name already taken" or give an internal error
		// and maybe it's a good idea to not just send error to client side
		InfoResponse(errMsg, err.Error()).Inform(w, http.StatusInternalServerError)
		return
	}

	InfoResponse("User created", "User created successfully. Now you can login!").Inform(w, http.StatusCreated)
}

func SignIn(w http.ResponseWriter, r *http.Request) {
	var creds dto.Credentials

	err := json.NewDecoder(r.Body).Decode(&creds)
	// TODO: better error handling
	if err != nil {
		InfoResponse("Something went wrong", "Couldn't process user input").Inform(w, http.StatusUnsupportedMediaType)
		return
	}

	err = validator.Validate.Struct(creds)

	if err != nil {
		// TODO : user friendly error
		InfoResponse("Invalid field nputs", err.Error()).Inform(w, http.StatusUnprocessableEntity)
		return
	}

	ctx := context.Background()
	tokens, err := users.Login(ctx, creds)

	if err != nil {
		// errors coming from  Login function should be user frienly
		// so there's no problem sending them to client side
		InfoResponse("Couldn't login", err.Error()).Inform(w, http.StatusInternalServerError)
		return
	}
	// TODO : Wrap sending tokens into a function
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(tokens)
}

func Refresh(w http.ResponseWriter, r *http.Request) {
	var refreshRoken string
	err := json.NewDecoder(r.Body).Decode(&refreshRoken)
	// only developer of client side should face errors in this part
	if err != nil {
		InfoResponse("Something went wrong", "Couldn't process user input").Inform(w, http.StatusUnsupportedMediaType)
		return
	}
	ctx := context.Background()
	tokens, err := users.RefreshTokens(ctx, refreshRoken)

	if err != nil {
		// again, like SignIn, errors coming from RefreshTokens function should
		// be user frienly so there's no problem sending them to client side
		InfoResponse("Couldn't login", err.Error()).Inform(w, http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(tokens)
}
