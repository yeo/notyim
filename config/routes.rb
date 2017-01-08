Rails.application.routes.draw do
  resources :receivers
  resources :verification, only: [:show, :create] do
    member do
      get 'verify'
      post 'resend'
      match 'interactive_voice', via: [:get, :post]
    end
  end

  resources :assertions do
    resources :alerts, only: [:create]
  end
  resources :alerts, only: [:update, :destroy]

  resources :checks
  resources :teams
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  #devise_for :users
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root to: 'home#index'
  get '/terms', to: 'page#term', as: 'show_term'
  get '/feedbacks', to: 'page#feedback', as: 'show_feedback'
  get '/docs', to: 'page#doc', as: 'show_doc'
  get '/dashboard', to: 'checks#index', as: 'user_root'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
