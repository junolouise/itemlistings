class ItemsController < ApplicationController
  ITEMS_URL = 'https://s3-eu-west-1.amazonaws.com/olio-staging-images/developer/test-articles-v4.json'.freeze

  before_action :set_item, only: %i[show edit update destroy like]
  before_action :fetch_items_and_users, only: :index

  # GET /items or /items.json
  def index
    @items = Item.all
  end

  # GET /items/1 or /items/1.json
  def show; end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit; end

  # POST /items or /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to item_url(@item), notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to item_url(@item), notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def like
    @item.likes += 1
    @item.save
    redirect_to items_path
  end

  private

  def fetch_items_and_users
    uri = URI(ITEMS_URL)
    response = Net::HTTP.get(uri)
    response_items = JSON.parse(response)
    response_items.each { |i| create_items_and_users(i)}
  end

  def create_items_and_users(response_item)
    item = Item.find_or_initialize_by(external_id: response_item['id'])
    user_data = response_item['user']
    user = User.find_or_initialize_by(external_id: user_data['id'])
    update_user(user, user_data)
    update_item(item, user, response_item)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
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

  # Only allow a list of trusted parameters through.
  def item_params
    params.require(:item).permit(:title, :thumbnail_url, :distance, :views, :likes, :user_id, :external_id)
  end
end
