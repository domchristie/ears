Rails.application.routes.draw do
  constraints subdomain: "websub" do
    get "web_subs/:id/feed", to: "web_subs#update", as: :web_sub_feed
    post "web_subs/:web_sub_id/feed", to: "web_subs/feeds#update"
  end

  resources :entries, only: :show do
    resources :plays, only: [:create, :update], controller: "entries/plays"
  end

  resources :opml_imports, only: [:new, :create]
  resources :feeds, only: [:index, :show]
  resources :entries, only: :show
  root "feeds#index"
end
