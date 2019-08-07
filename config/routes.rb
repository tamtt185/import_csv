Rails.application.routes.draw do
  root to: "users#index"
  resources :users

  namespace :imports do
    resources :users, only: :create
  end
end
