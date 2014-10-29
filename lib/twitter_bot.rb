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

  def self.tweet_comment_if_loved!(comment_id)

    comment = Comment.find(comment_id) || (return nil)

    if comment.related_evaluation and comment.related_evaluation.score > 2
      msg = tweet_msg_for(comment)
      puts self.new.client.update(msg)
    end
  end

  def self.tweet_msg_for(comment)

    body = "Les étudiants <3 leurs cours #{comment.item.schools.first.twitter_name}! #{comment.item.name}: #{comment.content}"

    long_url = "http://gogoreco.io/comments/#{comment.pretty_id}"
    #short_url = Googl.shorten(long_url).short_url
    #tail = "... #{short_url}"
    tail = "... #{long_url}"
    twitter_tail_size = 22 + 4 # 22 for any twitter link, 4 for the '... ' part

    body_size = 140 - twitter_tail_size
    msg = body[0..body_size - 1] + tail
    msg

  end
end
