Rails.application.routes.draw do
  devise_for :agents

  root "dashboard#show"

  resource :profile, only: [ :show, :edit, :update ]

  resources :clients

  resources :tours, except: [ :index ] do
    resources :properties, only: [ :new, :create, :edit, :update, :destroy ]
    resources :messages, only: [ :create ]
    resource :duplicate, only: [ :create ], module: :tours
    resource :recap, only: [ :show ], module: :tours
    resource :share, only: [ :show ], module: :tours
  end

  resources :suggestions, only: [ :index, :update ]

  resources :notifications, only: [ :index, :update ]
  # Marking every notification read is its own resource (REST, dedicated controller).
  resource :notification_reads, only: [ :update ]

  get "calendar", to: "calendar#show"
  get "search", to: "searches#show"

  # Public, token-based client portal — no agent authentication.
  # All routes scoped by the client's portal_token (e.g. /portal/abc123/tours).
  namespace :portal do
    scope ":token", as: :client do
      resources :tours, only: [ :index, :show ] do
        resources :messages, only: [ :create ]
        resources :suggestions, only: [ :create ]
        resources :ratings, only: [ :create, :update, :destroy ]
      end
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check
end
