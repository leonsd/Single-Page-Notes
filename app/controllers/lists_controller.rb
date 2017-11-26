class ListsController < ApplicationController
  respond_to :html, :js, :json
  before_action :set_list, only: [:add_collaborators, :edit, :update]

  def index
    new
    collection
  end

  def paginate
    collection

    render partial: 'lists', layout: false
  end

  def item_update
    item  = Item.find(params[:item_id])
    item.done = params[:done]
    item.save!

    list = List.find(params[:list_id])

    render partial: 'items', locals: { list: list }, layout: false
  end

  def color_update
    list = List.find(params[:list_id])
    list.color = params[:color]
    list.save!

    render partial: 'list', locals: { list: list }, layout: false
  end

  def delete_item
    item = Item.find(params[:item_id].to_i)
    item.destroy

    list = List.find(item.list_id)

    render partial: 'items', locals: { list: list }, layout: false
  end

  def new
    @list = List.new
    @list.user_id = current_user.id
  end

  def edit
    render layout: false
  end

  def create
    @list = List.new(list_params.merge(user: current_user))

    if @list.save
      list = List.where(user_id: current_user.id).last

      render partial: 'list', locals: { list: list }, layout: false
    end
  end

  def add_collaborators
    render partial: 'colaboradores', layout: false
  end

  def search_users
    render json: User.pluck(:email)
  end

  def update
    if @list.update_attributes(list_params)
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
    @lists = List.includes(:items)
                 .eager_load(:collaborators)
                 .my_or_shared(current_user)
                 .status(false)
                 .order('lists.created_at desc')
                 .page(params[:page])
                 .per(10)

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

  def search
    collection

    render partial: 'lists', layout: false
  end

  private
    def collection
      search = params[:keyword].present? ? params[:keyword] : nil

      if search
        @lists = List.search(search, fields: [:title],
            where: { 
              user: current_user.id,
              status:  true 
            },
            order: { date: :desc },
            page: params[:page],
            per_page: 10
          )
      else
        select_lists
      end
    end

    def select_lists
      @lists = List.includes(:items)
                   .eager_load(:collaborators)
                   .my_or_shared(current_user)
                   .status(true)
                   .order('lists.created_at desc')
                   .page(params[:page])
                   .per(10)
    end

    def set_list
      @list = List.find(params[:id])
    end

    def list_params
      params.require(:list).permit(:title, :color, items_attributes: [:id, :description, :done, :_destroy], collaborators_attributes: [:user_id, :_destroy])
    end
end