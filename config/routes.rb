Rails.application.routes.draw do
  # = Authenticating =
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

  # = Dashboarding =
  root "users/dashboards#show"
  resources :plays, only: :index
  # (Episodes encapsulate an entries with a user and their associated
  # plays/followings/playlists)
  resources :episodes, only: :index
  resource :play_later_playlist, only: :show, as: :play_later, path: "play_later" do
    scope module: :play_later_playlists do
      resources :items, only: :create
    end
  end

  # = Feeds & Entries
  resources :feeds, only: [:index, :show]
  resources :itunes_feeds, only: :show, path: "itunes", param: :apple_id

  resources :entries, only: :show do
    scope module: :entries do
      resources :plays, only: [:create, :update]
      resource :player, only: :show
      resource :table_of_contents, only: :show, path: "toc"
    end
  end

  # = Searching =
  namespace :directories do
    resource :search, only: [:new, :show]
  end

  # = Following & Playing Later =
  scope :list_items, as: :list_items, defaults: {variant: :list_items} do
    resources :feeds, only: [] do
      resource :following, only: [:create, :destroy]
    end

    resource :play_later_playlist, only: [], as: :play_later, path: "play_later" do
      resources :items, only: :destroy, param: :entry_id, controller: "play_later_playlists/items"
    end
  end

  # = Importing =
  resources :opml_imports, only: [:new, :create]
  constraints subdomain: "websub" do
    get "web_subs/:id/feed", to: "web_subs#update", as: :web_sub_feed
    post "web_subs/:web_sub_id/feed", to: "web_subs/feeds#update"
  end

  # = Etc =
  resources :settings, only: :index
  get "blank", to: "application#blank"
end
