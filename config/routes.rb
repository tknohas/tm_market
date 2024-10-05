Rails.application.routes.draw do
  root 'home#index'

  devise_for :admins, controllers: {
    sessions: 'admins/sessions'
  }
  namespace :admin do
    root to: "home#index"
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
end
