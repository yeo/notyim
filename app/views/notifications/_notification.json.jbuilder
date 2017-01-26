json.extract! notification, :id, :assertion_id, :check_id, :content, :created_at, :updated_at
json.url notification_url(notification, format: :json)