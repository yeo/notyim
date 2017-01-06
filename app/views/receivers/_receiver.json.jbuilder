json.extract! receiver, :id, :user_id, :provider, :handler, :require_verify, :verified, :created_at, :updated_at
json.url receiver_url(receiver, format: :json)