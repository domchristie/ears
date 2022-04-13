Rails.application.routes.draw do
  resources :opml_imports, only: [:new, :create]
  resources :feeds, only: :index
  root "feeds#index"
end
