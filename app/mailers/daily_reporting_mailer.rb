class DailyReportingMailer < ActionMailer::Base
  default from: "report@gogoreco.com"

  def daily_new_comments_report
    @start_time = Time.now - 24.hours
    @end_time = Time.now
    @comments = Item.gte(updated_at: Date.today).flat_map(&:comments).select{|c| (c.created_at >= Date.today) rescue nil}.compact
    mail(
      to: "moderate@gogoreco.com",
      subject: "[GOGORECO DAILY REPORT]: #{@comments.count} new comment(s)",
    )
  end

end
