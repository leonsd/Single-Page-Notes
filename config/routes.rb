Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'lists#index'

  devise_for :users do
    get "/logout" => "devise/sessions#destroy", :as => :destroy_user_session
  end

  resources :users
  
  resources :lists do
    get 'paginate',          on: :collection
    get 'list_destroy',      on: :collection
    get 'rollback_list',     on: :collection
    get 'item_update',       on: :collection
    get 'color_update',      on: :collection
    get 'delete_item',       on: :collection
    get 'add_collaborators', on: :collection
    get 'search_users',      on: :collection  
    get 'notes',             on: :collection
    get 'trash',             on: :collection
    get 'search',            on: :collection
  end
end
