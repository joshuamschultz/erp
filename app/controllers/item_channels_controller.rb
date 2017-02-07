class ItemChannelsController < ApplicationController
  before_action :set_item_channel, only: [:show, :edit, :update, :destroy]

  # GET /item_channels
  def index
    @item_channels = ItemChannel.all
  end

  # GET /item_channels/1
  def show
  end

  # GET /item_channels/new
  def new
    @item_channel = ItemChannel.new
  end

  # GET /item_channels/1/edit
  def edit
  end

  # POST /item_channels
  def create
    @item_channel = ItemChannel.new(item_channel_params)

    if @item_channel.save
      redirect_to @item_channel, notice: 'Item channel was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /item_channels/1
  def update
    if @item_channel.update(item_channel_params)
      redirect_to @item_channel, notice: 'Item channel was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /item_channels/1
  def destroy
    @item_channel.destroy
    redirect_to item_channels_url, notice: 'Item channel was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item_channel
      @item_channel = ItemChannel.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def item_channel_params
      params.require(:item_channel).permit(:item_revision_id, :channel, :channel_item_id)
    end
end
