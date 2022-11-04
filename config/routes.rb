Rails.application.routes.draw do
  get "signup", to: "users#new"
  post "signup", to: "users#create"
  resources :confirmations, only: [:edit, :new, :create], param: :confirmation_token
  get "account", to: "users#edit"
  put "account", to: "users#update"
  delete "account", to: "users#destroy"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  resources :passwords, only: [:new, :create, :edit, :update], param: :password_reset_token

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
  resources :feeds, only: :show do
    resources :followings, only: [:create], controller: "feeds/followings"
  end

  root "users/dashboards#show"
end
