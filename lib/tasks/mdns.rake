task mdns: :environment do
  require "mdns"
  local_ip = `ifconfig -l | xargs -n1 ipconfig getifaddr`.split("\n").first

  puts "Adding mDNS record for listen.local"
  MDNS.add_record("app.listen.local", 60, local_ip)
  MDNS.add_record("websub.listen.local", 60, local_ip)

  MDNS.start
  puts "mDNS started"

  while true
    sleep(60)
    puts "mDNS heartbeat"
  end
end
