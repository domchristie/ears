Rails.application.routes.draw do
  get 'entries/show'
  resources :opml_imports, only: [:new, :create]
  resources :feeds, only: [:index, :show]
  resources :entries, only: :show
  root "feeds#index"
end
