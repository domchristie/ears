namespace :web_subs do
  task renew: :environment do
    Feed.renew_web_subs
  end

  # Deprecated: kept so existing Heroku Scheduler jobs still work
  namespace :renew do
    task expiring: "web_subs:renew"
    task expired: "web_subs:renew"
  end

  namespace :destroy do
    task all: :environment do
      WebSub.delete_all
    end
  end

  namespace :start do
    task all: :environment do
      Feed.web_subable.each(&:start_web_sub)
    end
  end
end
