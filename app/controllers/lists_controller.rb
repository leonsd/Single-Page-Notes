class ListsController < ApplicationController
  respond_to :html, :js, :json
  before_action :set_list, only: [:edit, :update]

  def index
    new
    collection
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

  def update
  end

  def notes
    new
    select_lists

    render :index, layout: false
  end

  def trash
    @lists = List.includes(:items)
                 .my_notes(current_user)
                 .status(false)
                 .order('items.done', 
                        'items.description asc',
                        'lists.created_at desc')
    
    render partial: 'lists', layout: false
  end

  def list_destroy
    @list = List.find(params[:list_id])
    @list.status = false
    @list.save
    
    render json: true
  end

  def rollback_list
    @list = List.find(params[:list_id])
    @list.status = true
    @list.save

    render partial: 'list', locals: { list: @list }, layout: false
  end

  private
    def collection
      search = params[:keyword].present? ? params[:keyword] : nil

      if search
        @lists = List.search(search,
            where: { 
              user: current_user.id,
              status:  true 
            },
            order: [
              { complete: :asc },
              { date: :desc }
            ]
          )
      else
        select_lists
      end
    end

    def select_lists
      @lists = List.includes(:items)
                   .my_notes(current_user)
                   .status(true)
                   .order('items.done asc', 
                          'lists.created_at desc')
    end

    def set_list
      @list = List.find(params[:id])
    end

    def list_params
      params.require(:list).permit(:title, :color, items_attributes: [:id, :description, :done, :_destroy])
    end
end