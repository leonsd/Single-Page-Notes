class ListsController < ApplicationController
  before_action :set_list, only: [:show, :edit, :update, :destroy]

  def index
    new
    select_lists
  end

  def item_update
    item = Item.find(params[:item_id])
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

  def show
  end

  def new
    @list = List.new
    @list.items.build
  end

  def edit
  end

  def create
    @list = List.new(list_params)

    respond_to do |format|
      if @list.save
        format.html { redirect_to lists_path, notice: 'Lista Criada!' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @list.destroy

    respond_to do |format|
      format.html { redirect_to lists_url, notice: 'Lista Apagada!' }
    end
  end

  private
    def select_lists
      @lists = List.includes(:items).order('items.done', 'items.created_at')
    end

    def set_list
      @list = List.find(params[:id])
    end

    def list_params
      params.require(:list).permit(:title, :color, items_attributes: [:id, :description, :done, :_destroy])
    end
end
