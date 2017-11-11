class ListsController < ApplicationController
  respond_to :html, :js
  before_action :set_list, only: [:edit, :update]

  def index
    new
    select_lists
  end

  def item_update
    item  = Item.find(params[:item_id])
    # lista = item.list
    item.done = params[:done]
    item.save!
 
    select_lists

    render partial: 'lists', layout: false
  end

  def color_update
    list = List.find(params[:list_id].to_i)
    list.color = params[:color]
    list.save!

    select_lists

    render partial: 'lists', layout: false
  end

  def delete_item
    item = Item.find(params[:item_id].to_i)
    item.destroy

    select_lists

    render partial: 'lists', layout: false
  end

  def new
    @list = List.new
    @list.items.build
  end

  def edit
  end

  def create
    @list = List.new(list_params)

    if @list.save
      list = List.last

      render partial: 'list', locals: { list: list }, layout: false
    else
      render :new
    end
  end

  def list_destroy
    @list = List.find(params[:list_id])
    @list.destroy
    
    render json: true
  end

  private
    def select_lists
      @lists = List.includes(:items).order('items.done', 'items.created_at DESC')
    end

    def set_list
      @list = List.find(params[:id])
    end

    def list_params
      params.require(:list).permit(:title, :color, items_attributes: [:id, :description, :done, :_destroy])
    end
end
