Rails.application.routes.draw do
  resources :orders, only: [:new, :create]
  resources :comments, only: [:index, :create, :destroy]
  resources :favorites, only: [:index, :create, :destroy]
  resources :products
  resources :carts, only: :show

  # カード操作用
  post "/add_item", to: "carts#add_item"
  post "/update_item", to: "carts#update_item"
  delete "/delete_item", to: "carts#delete_item"

  # 商品並べ替え用
  get "products_sort", to: "products#sort", as: "products/sort"

  get "image_detail", to: "products#image_detail"

  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    unlocks: 'users/unlocks'
  }
  # devise_forより前にresourcesで指定すると、users/***の***がshowアクションの引数として識別されてしまう
  resources :users, only: [:index, :show]

  root to: "pages#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
