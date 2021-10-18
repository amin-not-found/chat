package dto

type SignUpUser struct {
	Username string `validate:"required,min=3"`
	Password string `validate:"required,min=6"`
	Name     string `validate:"required,min=1"`
}

type Credentials struct {
	Username string `validate:"required"`
	Password string `validate:"required"`
}
