package users

import (
	"context"
	"errors"
	"log"
	"server/ent/user"
	"server/internal/services"
	"server/pkg/dto"
)

// return error and friendly error title
func CreateUser(ctx context.Context, username string, password string, name string) (string, error) {

	// check if user exists
	// ent should prevent me from making user with same username
	// but it's a bit hard to tell user "username already taken" based on that
	// TODO : above line

	passwordHash, err := HashPassword(password)

	if err != nil {
		log.Printf("Couldn't hash password for new user: %s\nerr: %s", username, err)
		return "Something went wrong", err
	}

	_, err = services.EntClient.User.Create().
		SetUsername(username).
		SetPasswordHash(string(passwordHash)).
		SetName(name).
		Save(ctx)

	if err != nil {
		return "Couldn't create user", err
	}

	return "User created", nil
}

func Login(ctx context.Context, creds dto.Credentials) (dto.Tokens, error) {
	// TODO : check if user exists and check password
	user, err := services.EntClient.User.
		Query().
		Where(user.Username(creds.Username)).
		// only will error if not found or found more than 1
		Only(ctx)
	if err != nil {
		// TODO : Maybe handle the error better
		return dto.Tokens{}, err
	}

	if correctPassword := CheckPasswordHash(creds.Password, user.PasswordHash); !correctPassword {
		return dto.Tokens{}, errors.New("incorrect username or password")
	}

	tokens, err := generateTokens(ctx, user)
	if err != nil {
		// TODO : figure out if it will yeild 500 status code in the end
		return dto.Tokens{}, errors.New("server error")
	}

	return tokens, err
}
