Rails.application.routes.draw do
  scope :list_items, as: :list_items, defaults: {variant: :list_items} do
    resources :feeds, only: [] do
      resource :following, only: [:create, :destroy]
    end
  end

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
    scope module: :entries do
      resources :plays, only: [:create, :update]
      resource :player, only: :show
      resource :table_of_contents, only: :show, path: "toc"
    end
  end

  resources :opml_imports, only: [:new, :create]

  get "feeds/:encoded_url", to: "feeds#show", constraints: {encoded_url: %r{encoded_url.+}}
  resources :feeds, only: [:index, :show]

  resource :queue, only: :show do
    scope module: :queues do
      resources :items, only: :create
    end
  end

  resources :plays, only: [:index]
  resources :episodes, only: [:index]

  root "users/dashboards#show"
end
