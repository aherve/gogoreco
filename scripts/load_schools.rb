File.open("./schools.csv").each_line do |l|
  ll = l.chomp.split("\t").map(&:strip)
  s = School.find_or_create_by(name: ll.first)
  s.twitter_id = ll[1]
  s.twitter_username = ll[2]
  puts s.save
end
