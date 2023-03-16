Rails.application.routes.draw do
  get "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"
  get "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"
  resources :sessions, only: [:index, :show, :destroy]
  resource :password, only: [:edit, :update]
  namespace :identity do
    resource :email, only: [:edit, :update]
    resource :email_verification, only: [:edit, :create]
    resource :password_reset, only: [:new, :edit, :create, :update]
  end

  namespace :directories do
    resource :search, only: [:new, :show]
  end

  resources :settings, only: :index

  constraints subdomain: "websub" do
    get "web_subs/:id/feed", to: "web_subs#update", as: :web_sub_feed
    post "web_subs/:web_sub_id/feed", to: "web_subs/feeds#update"
  end

  resources :entries, only: :show do
    resources :plays, only: [:create, :update], controller: "entries/plays"
    resource :player, only: :show, controller: "entries/players"
    resource :table_of_contents, only: :show, controller: "entries/table_of_contents", path: "toc"
  end

  resources :opml_imports, only: [:new, :create]

  get "feeds/:encoded_url", to: "feeds#show", constraints: {encoded_url: %r{encoded_url.+}}
  resources :feeds, only: [:index, :show] do
    resources :followings, only: [:create], controller: "feeds/followings"
  end

  resource :queue, only: :show do
    resources :items, only: :create, controller: "queues/items"
  end

  resources :plays, only: [:index]
  resources :episodes, only: [:index]

  root "users/dashboards#show"
end
