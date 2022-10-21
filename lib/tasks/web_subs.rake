namespace :web_subs do
  namespace :renew do
    task expiring: :environment do
      WebSub.expiring.each { |web_sub| RenewWebSubJob.perform_now(web_sub) }
    end

    task expired: :environment do
      WebSub.expired.each { |web_sub| RenewWebSubJob.perform_now(web_sub) }
    end
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
