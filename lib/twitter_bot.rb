require 'twitter'
class TwitterBot
  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = TWITTER_APP_CONSUMER_KEY
      config.consumer_secret     = TWITTER_APP_CONSUMER_SECRET
      config.access_token        = TWITTER_APP_ACCESS_TOKEN
      config.access_token_secret = TWITTER_APP_ACCESS_TOKEN_SECRET
    end
  end

  def timeline_selection(seconds)
    client.home_timeline(count: 1000)
    .select{|t| t.created_at > Time.now - seconds}
    .select{|t| t.retweet_count > 1 or t.favorite_count > 1}
    .reject(&:favorited?)
  end

  def favorite_feed_selection!(s=3600)
    timeline_selection(s).each{|t| puts client.favorite t}
    puts "done"
  end

  def self.favorite_feed_selection!(s=3600)
    self.new.favorite_feed_selection!(s)
  end

end
