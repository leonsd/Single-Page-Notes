class ListsController < ApplicationController
  respond_to :html, :js
  before_action :set_list, only: [:edit, :update]

  def index
    new
    select_lists
  end

  def item_update
    item  = Item.find(params[:item_id])
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
    @list.user_id = current_user.id
  end

  def edit
  end

  def create
    @list = List.new(list_params)
    @list.user_id = current_user.id

    if @list.save
      list = List.where(user_id: current_user.id).last

      render partial: 'list', locals: { list: list }, layout: false
    end
  end

  def notes
    new
    select_lists

    render :index, layout: false
  end

  def trash
    @lists = List.where(user_id: current_user.id).where(status: false)
    
    render partial: 'lists', layout: false
  end

  def list_destroy
    @list = List.find(params[:list_id])
    
    if params[:rollback]
      @list.status = true
    else
      @list.status = false
    end

    @list.save
    
    render json: true
  end

  private
    def select_lists
      @lists = List.includes(:items)
                   .where(status: true)
                   .order('items.done', 'items.created_at desc')
    end

    def set_list
      @list = List.find(params[:id])
    end

    def list_params
      params.require(:list).permit(:title, :color, items_attributes: [:id, :description, :done, :_destroy])
    end
end
