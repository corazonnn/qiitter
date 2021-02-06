Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root 'products#index'
  get 'toppages/index'
  get 'users/show' #ユーザのマイページ
  resources :products
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
