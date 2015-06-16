class Notifier < ActionMailer::Base
  default from: "noreply@nafasi.co"

  def send_idea_completion_email(user, idea)
    @user = user
    @idea = idea
    
    mail( :to => 'idea@nafasi.co',
    :subject => "COMPLETION: #{user.email} finished #{idea.name}" )
  end
end
