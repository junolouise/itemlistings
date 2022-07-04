module ItemFetchable
  extend ActiveSupport::Concern

  ITEMS_URL = 'https://s3-eu-west-1.amazonaws.com/olio-staging-images/developer/test-articles-v4.json'.freeze

  included do
    before_action :fetch_items_and_users, only: :index
  end

  def fetch_items_and_users
    uri = URI(ITEMS_URL)
    response = Net::HTTP.get(uri)
    response_items = JSON.parse(response)
    response_items.each { |i| create_items_and_users(i)}
  end

  private

  def create_items_and_users(response_item)
    item = Item.find_or_initialize_by(external_id: response_item['id'])
    user_data = response_item['user']
    user = User.find_or_initialize_by(external_id: user_data['id'])
    update_user(user, user_data)
    update_item(item, user, response_item)
  end

  def update_user(user, user_data)
    user.update(display_picture: user_data.dig('current_avatar', 'small'),
                rating: user_data.dig('rating', 'rating'),
                name: user_data['first_name'])
  end

  def update_item(item, user, response_item)
    item.update(title: response_item['title'],
                thumbnail_url: response_item['photos'][0].dig('files', 'medium'),
                distance: response_item.dig('location', 'distance'),
                views: response_item.dig('reactions', 'views'),
                external_id: response_item['id'],
                user: user)
  end
end