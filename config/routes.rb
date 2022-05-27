Rails.application.routes.draw do
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  resources :settings, only: :index

  namespace :users do
    resource :dashboard, only: :show
  end

  constraints subdomain: "websub" do
    get "web_subs/:id/feed", to: "web_subs#update", as: :web_sub_feed
    post "web_subs/:web_sub_id/feed", to: "web_subs/feeds#update"
  end

  resources :entries, only: :show do
    resources :plays, only: [:create, :update], controller: "entries/plays"
    resource :player, only: :show, controller: "entries/players"
  end

  resources :opml_imports, only: [:new, :create]
  resources :feeds, only: :show
  resources :entries, only: :show
  root "users/dashboards#show"
end
