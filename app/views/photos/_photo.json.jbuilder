json.extract! photo, :id, :path, :alt_text, :description, :created_at, :updated_at
json.url photo_url(photo, format: :json)
