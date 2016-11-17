class FeedbackMailer < ActionMailer::Base
  default :from => "no-reply@muskokaroastery.com",
          :reply_to => "no-reply@muskokaroastery.com",
          "X-Time-Code" => Time.now.to_i.to_s

  def contact(feedback)
    @feedback = feedback
    mail( :to => Settings.email_notifications_address,
          :reply_to => @feedback.email,
          :subject => "MRCC Notification: New Feedback")
  end

  def password_reset_instructions(user)
    @user = user
    #@edit_password_reset_url = edit_password_reset_url(@user.perishable_token)
    mail( :to => @user.email,
          :subject => "Password Reset Instructions" )
  end
end
