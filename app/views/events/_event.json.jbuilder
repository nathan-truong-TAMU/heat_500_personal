json.extract! event, :id, :link, :name, :start_date, :end_date, :points, :description, :created_at, :updated_at
json.url event_url(event, format: :json)
