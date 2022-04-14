Time::DATE_FORMATS[:rfc7231] = lambda do |time|
  time.in_time_zone("GMT").strftime("%a, %d %b %Y %T %Z")
end
