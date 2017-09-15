class EventMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.event_mailer.notify_owner.subject
  #
  def notify_owner(event, text)
    @event = event
    @text = text
    # @user = current_user
    mail(to: "vincent.feildel@gmail.com", subject: "Lot #{@event.lease.num_lot} - #{@event.lease.tenant_address.capitalize} - #{@event.description.capitalize}")
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.event_mailer.notify_tenant.subject

  def notify_tenant(event, text)
    @event = event
    @text = text
    # @user = current_user
    mail(to: "vincent.feildel@gmail.com", subject: "#{@event.description}")
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.event_mailer.daily_task.subject
  #
  def daily_task
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end

