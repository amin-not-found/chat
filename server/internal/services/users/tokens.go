package users

import (
	"context"
	"errors"
	"fmt"
	"server/ent"
	"server/ent/user"
	"server/internal/services"
	"server/pkg/dto"
	"time"

	"github.com/golang-jwt/jwt"
)

type Claims struct {
	Username string
	Type     string
	jwt.StandardClaims
}

func generateTokens(ctx context.Context, user *ent.User) (dto.Tokens, error) {
	// TODO : check if errors are user friendly

	// TODO : change username to user id
	username := user.Username

	claims := Claims{
		Username: username,
		Type:     "access",
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: time.Now().Add(services.Config.AccessTokenDuration).Unix(),
		},
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	accessToken, err := token.SignedString(services.Config.AuthSecret)
	if err != nil {
		// TODO : handle Error
		return dto.Tokens{}, err
	}

	// it's a variable this time bc we need it in future in order to differentiate between rotated refresh tokens
	refreshTokenExpiry := time.Now().Add(services.Config.RefreshTokenDuration).Unix()
	claims = Claims{
		Username: username,
		Type:     "refresh",
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: refreshTokenExpiry,
		},
	}
	token = jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	refreshToken, err := token.SignedString(services.Config.AuthSecret)
	if err != nil {
		// TODO : handle Error
		return dto.Tokens{}, err
	}

	tokens := dto.NewTokens(accessToken, refreshToken, refreshTokenExpiry)

	_, err = user.Update().ClearRefreshTokenExpiry().SetRefreshTokenExpiry(refreshTokenExpiry).Save(ctx)
	if err != nil {
		// TODO : better return some user friendly error, not error received from ent
		return dto.Tokens{}, err
	}

	return tokens, nil
}

func tokenKeyFunc(token *jwt.Token) (interface{}, error) {
	// validate the alg is what you expect:
	if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
		return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
	}
	return services.Config.AuthSecret, nil
}

func VerifyToken(tokenStr string) (jwt.MapClaims, error) {
	claims := jwt.MapClaims{}

	_, err := jwt.ParseWithClaims(tokenStr, claims, tokenKeyFunc)
	if err != nil {
		return jwt.MapClaims{}, err
	}
	return claims, nil
}

var errRefresh = errors.New("there was some problem logging in. Signing again is recommanded, specially for security reasons")

// TODO : this function is getting a bit messy. maybe it can be refactored
func RefreshTokens(ctx context.Context, tokenStr string) (dto.Tokens, error) {
	claims := jwt.MapClaims{}

	_, err := jwt.ParseWithClaims(tokenStr, claims, tokenKeyFunc)
	if err != nil {
		// TODO  : This error NEEDS to be handled better
		// and it should become user friendly
		fmt.Println("error in getting claims for refresh token")
		fmt.Println(err)
		return dto.Tokens{}, err
	}

	// check if claims contains username and exp keys
	for _, v := range []string{"Username", "exp"} {
		if _, ok := claims[v]; !ok {
			return dto.Tokens{}, errRefresh
		}
	}
	// check if type key exists and is set to "refresh"
	if val, ok := claims["Type"]; ok {
		if val.(string) != "refresh" {
			return dto.Tokens{}, errRefresh
		}
	} else {
		return dto.Tokens{}, errRefresh
	}

	user, err := services.EntClient.User.Query().Where(user.Username(claims["Username"].(string))).Only(ctx)
	if err != nil {
		// TODO : "ErRoR hANdLiNg"
		fmt.Println("Error in getting user with claims:")
		fmt.Println(claims)
		fmt.Println(err)
		return dto.Tokens{}, err
	}

	exp := claims["exp"].(float64)
	// chack if there's no error and also be sure that expiry
	// date in token is equal to expiry date in database
	if err != nil || *user.RefreshTokenExpiry != int64(exp) {
		fmt.Println("Expiration date isn't correct")
		fmt.Println(*user.RefreshTokenExpiry)
		fmt.Println(int64(exp))
		return dto.Tokens{}, errRefresh
	}

	tokens, err := generateTokens(ctx, user)

	if err != nil {
		// TODO : here we go again
		// "la gestion des erreurs"
		return dto.Tokens{}, err
	}

	return tokens, nil
}
