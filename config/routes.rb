Rails.application.routes.draw do
  resources :charges
  resources :verification, only: [:show, :create] do
    member do
      get 'verify'
      post 'resend'
      match 'interactive_voice', via: [:get, :post]
    end
  end

  resources :checks
  resources :assertions
  resources :incidents
  resources :receivers
  post '/incident_receivers/:check_id', to: 'incident_receivers#create', as: :register_incident_receivers

  resources :teams
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  #devise_for :users
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root to: 'home#index'
  get '/terms', to: 'page#term', as: 'show_term'
  get '/feedbacks', to: 'page#feedback', as: 'show_feedback'
  get '/about', to: 'page#about', as: 'show_about'
  get '/docs', to: 'page#doc', as: 'show_doc'
  get '/dashboard', to: 'checks#index', as: 'user_root'
  namespace :users do
    get 'plans', to: 'plans#show', as: 'show_plans'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
