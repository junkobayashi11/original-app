Rails.application.routes.draw do
  devise_for :users
  root to: 'rooms#index'
  resources :users, only: :show
  resources :rooms do
    resources :comments, only: :create
  end
end
 