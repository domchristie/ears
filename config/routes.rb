Rails.application.routes.draw do
  resources :opml_imports
  resources :feeds, only: :index
  root "feeds#index"
end
