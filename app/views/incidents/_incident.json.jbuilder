json.extract! incident, :id, :check_id, :status, :acknowledged_at, :created_at, :updated_at
json.url incident_url(incident, format: :json)