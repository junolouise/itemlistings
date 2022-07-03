class ItemsController < ApplicationController
  ITEMS_URL = 'https://s3-eu-west-1.amazonaws.com/olio-staging-images/developer/test-articles-v4.json'.freeze

  before_action :set_item, only: %i[show edit update destroy]
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

  private

  def fetch_items_and_users
    uri = URI(ITEMS_URL)
    response = Net::HTTP.get(uri)
    response_items = JSON.parse(response)
    response_items.each do |i|
      item = Item.find_or_create_by(external_id: i['id'])
      user_data = i['user']
      user = User.find_or_create_by(external_id: user_data['id'])
      item.update(title: i['title'],
                  thumbnail_url: i['photos'][0].dig('files', 'medium'),
                  distance: i.dig('location', 'distance'),
                  views: i.dig('reactions', 'views'),
                  likes: 0,
                  external_id: i['id'],
                  user: user)
      user.update(display_picture: user_data.dig('current_avatar', 'small'),
                  rating: user_data.dig('rating', 'rating'),
                  name: user_data['first_name'])
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def item_params
    params.require(:item).permit(:title, :thumbnail_url, :distance, :views, :likes)
  end
end
