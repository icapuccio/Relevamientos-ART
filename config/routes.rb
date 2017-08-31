Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { :sessions => 'sessions' },
                               path_names: { sign_in: 'login', sign_out: 'logout' }

  root to: 'application#index'

  resources :visits, only: [:index]

  require 'sidekiq/web'
  mount Sidekiq::Web, at: 'sidekiq'
  mount PgHero::Engine, at: 'pghero'
end
