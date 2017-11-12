Rails.application.routes.draw do
  default_url_options host: 'relevamientosdigitales.com'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { sessions: 'sessions' },
                               path_names: { sign_in: 'login', sign_out: 'logout' }
  devise_scope :user do
    get '/login' => 'devise/sessions#new', as: 'login'
  end

  root 'visits#index'
  get :help, to: 'home#help'

  resources :visits, only: [:index, :show, :edit, :update] do
    post :assignment, to: 'visits#assign'
    put :remotion, to: 'visits#remove_assignment'
    put :completion, to: 'visits#complete'
    collection do
      get :assignment, to: 'visits#assignment_index'
      get :automatic_assignment, to: 'visits#automatic_assignment_index'
      post :completed_report, to: 'visits#completed_report'
      get :completed_report, to: 'visits#completed_report_index'
      get :finished_report, to: 'visits#finished_report_index'
      get :report, to: 'visits#report_index'
      post :syncro_visits
      post :auto_assignments
      post :auto_assignments2
    end
  end
  resources :institutions, only: [:show]

  resources :tasks, only: :none do
    put :completion, to: 'tasks#complete'
  end

  resources :users, only: :none, defaults: { format: :json } do
    collection  do
      post 'new_password_request', to: 'users#reset_password'
    end
    put 'new_password', to: 'users#update_password'
  end
  require 'sidekiq/web'
  mount Sidekiq::Web, at: 'sidekiq'
  mount PgHero::Engine, at: 'pghero'
end
