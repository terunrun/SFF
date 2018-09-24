Rails.application.routes.draw do
  resources :orders, only: [:new, :create]
  resources :comments, only: [:index, :create, :destroy]
  resources :favorites, only: [:index, :create, :destroy]
  resources :products
  get "products_sort", to: "products#sort", as: "products/sort"

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
