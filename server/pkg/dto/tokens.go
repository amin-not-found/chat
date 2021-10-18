package dto

type Tokens struct {
	AccessToken        string
	RefreshToken       string
	RefreshTokenExpiry int64
}

func NewTokens(aToken string, rToken string, rtExpiry int64) Tokens {
	return Tokens{
		AccessToken:        aToken,
		RefreshToken:       rToken,
		RefreshTokenExpiry: rtExpiry,
	}
}
