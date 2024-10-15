json.extract! event, :id, :link, :name, :start_date, :end_date, :points, :description, :created_at, :updated_at, :catgory, :location
json.url event_url(event, format: :json)
