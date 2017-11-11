Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'lists#index'

  resources :lists do
    get 'list_destroy', on: :collection
    get 'item_update',  on: :collection
    get 'color_update', on: :collection
    get 'delete_item',  on: :collection
  end
end
