class DailyReportingMailer < ActionMailer::Base
  default from: "report@gogoreco.com"

  def daily_new_comments_report
    @start_time = Time.now - 24.hours
    @end_time = Time.now
    @comments = Comment.gte(created_at: Date.today)
    mail(
      to: "moderate@shapter.com",
      subject: "[GOGORECO DAILY REPORT]: #{@comments.count} new comment(s)",
    )
  end

end
