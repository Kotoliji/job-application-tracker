# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#index"

  resources :organizations do
    resources :opportunities, only: %i[new create], shallow: true
  end

  resources :opportunities, except: %i[new create] do
    resources :channels, only: %i[new create], shallow: true
  end

  resources :channels, except: %i[new create] do
    resources :submission_events, only: %i[create], shallow: true
  end
end
