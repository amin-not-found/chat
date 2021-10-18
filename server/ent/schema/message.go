package schema

import (
	"entgo.io/ent"
	"entgo.io/ent/schema/edge"
	"entgo.io/ent/schema/field"
)

// Message holds the schema definition for the Message entity.
type Message struct {
	ent.Schema
}

// Fields of the Message.
func (Message) Fields() []ent.Field {
	return []ent.Field{
		field.String("type"),
		field.String("content"),
		field.Time("time"),
		// ID of message in sender local database
		field.Int64("local_id"),
		// The value is gonna be true whenever message sender knows their message was received and they wouldn't resend it
		field.Bool("can_be_deleted"),
	}
}

// Edges of the Message.
func (Message) Edges() []ent.Edge {
	return []ent.Edge{
		edge.From("receivers", User.Type).Ref("unrecived_messages"),
		edge.From("sender", User.Type).Ref("undelivered_messages").Unique(),
	}
}
