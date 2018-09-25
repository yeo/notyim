package noty

// NewStatus build a status request object
func NewStatus(body []byte) *Request {
	return &Request{
		Method:   "POST",
		Endpoint: "status",
		Body:     body,
	}
}
