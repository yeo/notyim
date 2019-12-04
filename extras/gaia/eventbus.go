package gaia

import (
	"encoding/json"
	"fmt"
)

type EventWrapper struct {
	EventType EventType
}

type GenericEvent struct {
	EventType EventType
	*EventCheckInsert
	*EventCheckReplace
	*EventCheckDelete

	*EventRunCheck

	*EventCheckHTTPResult
	*EventCheckTCPResult

	*EventPing
}

func (e *GenericEvent) UnmarshalJSON(data []byte) error {
	var temp EventWrapper

	if err := json.Unmarshal(data, &temp); err != nil {
		return fmt.Errorf("Unmarshal event error: %w", err)
	}

	switch temp.EventType {
	case EventTypeCheckInsert:
		var cmd EventCheckInsert
		if err := json.Unmarshal(data, &cmd); err != nil {
			return fmt.Errorf("Unmarshal event error: %w", err)
		}

		e.EventCheckInsert = &cmd
		e.EventType = EventTypeCheckInsert

	case EventTypeCheckReplace:
		var cmd EventCheckReplace
		if err := json.Unmarshal(data, &cmd); err != nil {
			return fmt.Errorf("Unmarshal event error: %w", err)
		}
		e.EventCheckReplace = &cmd
		e.EventType = EventTypeCheckReplace

	case EventTypeCheckDelete:
		var cmd EventCheckDelete
		if err := json.Unmarshal(data, &cmd); err != nil {
			return fmt.Errorf("Unmarshal event error: %w", err)
		}
		e.EventCheckDelete = &cmd
		e.EventType = EventTypeCheckDelete

	case EventTypeRunCheck:
		var cmd EventRunCheck
		if err := json.Unmarshal(data, &cmd); err != nil {
			return fmt.Errorf("Unmarshal event error: %w", err)
		}

		e.EventRunCheck = &cmd
		e.EventType = EventTypeRunCheck

	case EventTypeCheckHTTPResult:
		var cmd EventCheckHTTPResult
		if err := json.Unmarshal(data, &cmd); err != nil {
			return fmt.Errorf("Unmarshal event error: %w", err)
		}

		e.EventCheckHTTPResult = &cmd
		e.EventType = EventTypeCheckHTTPResult

	case EventTypeCheckTCPResult:
		var cmd EventCheckTCPResult
		if err := json.Unmarshal(data, &cmd); err != nil {
			return fmt.Errorf("Unmarshal event error: %w", err)
		}

		e.EventCheckTCPResult = &cmd
		e.EventType = EventTypeCheckTCPResult

	case EventTypePing:
		var cmd EventPing
		if err := json.Unmarshal(data, &cmd); err != nil {
			return fmt.Errorf("Unmarshal event error: %w", err)
		}

		e.EventPing = &cmd
		e.EventType = EventTypePing
	}

	return nil
}
