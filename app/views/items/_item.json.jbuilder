json.extract! item, :id, :title, :thumbnail_url, :distance, :views, :likes, :created_at, :updated_at
json.url item_url(item, format: :json)
