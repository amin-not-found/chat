package schema

import (
	"entgo.io/ent"
	"entgo.io/ent/schema/edge"
	"entgo.io/ent/schema/field"
)

// User holds the schema definition for the User entity.
type User struct {
	ent.Schema
}

// Fields of the User.
func (User) Fields() []ent.Field {
	return []ent.Field{
		field.String("username").NotEmpty().Unique().MinLen(3),
		field.String("name").NotEmpty(),
		field.String("password_hash").NotEmpty(),
		field.String("bio").Optional().Nillable(),
		field.Time("last_seen").Optional().Nillable(),
		// Expiry date in unix echo format
		field.Int64("refresh_token_expiry").Optional().Nillable(),
		// maybe birthday
		// Maybe ome authentication shit
	}
}

// Edges of the User.
func (User) Edges() []ent.Edge {
	return []ent.Edge{
		edge.To("unrecived_messages", Message.Type),
		edge.To("undelivered_messages", Message.Type),
	}
}
