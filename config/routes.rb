Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root to: 'home#index'
  get '/terms', to: 'page#term', as: 'show_term'
  get '/feedbacks', to: 'page#feedback', as: 'show_feedback'
  get '/docs', to: 'page#doc', as: 'show_doc'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
