class EventMailerPreview < ActionMailer::Preview
  def notify_owner
    event = Event.last
    text = "Coucou, comment vas-tu?"
    EventMailer.notify_owner(event, text)
  end

end
