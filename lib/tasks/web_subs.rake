namespace :web_subs do
  namespace :renew do
    task expiring: :environment do
      WebSub.expiring.each { |web_sub| RenewWebSubJob.perform_now(web_sub) }
    end

    task expired: :environment do
      WebSub.expired.each { |web_sub| RenewWebSubJob.perform_now(web_sub) }
    end
  end
end
