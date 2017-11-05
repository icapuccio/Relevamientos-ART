Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { sessions: 'sessions' },
                               path_names: { sign_in: 'login', sign_out: 'logout' }
  devise_scope :user do
    get '/login' => 'devise/sessions#new', as: 'login'
  end

  root 'home#index'

  resources :visits, only: [:index, :show, :edit, :update] do
    post :assignment, to: 'visits#assign'
    put :remotion, to: 'visits#remove_assignment'
    put :completion, to: 'visits#complete'
    collection do
      get :assignment_index
    end
  end
  resources :institutions, only: [:show]

  require 'sidekiq/web'
  mount Sidekiq::Web, at: 'sidekiq'
  mount PgHero::Engine, at: 'pghero'
end
