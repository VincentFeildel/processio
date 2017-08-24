class PagesController < ApplicationController
  def home
    @user = current_user

    # Circular progress bar data:
    @percentage_done = (Event.where(to_do: false).count.fdiv(Event.all.count)*100).round
    p = 0
    Event.where(status: 'tenant_to_notify').each do |e|
      p += 1 if e.description != 'retard loyer'
    end
    @percentage_progress = (p.fdiv(Event.all.count)*100).round

    #Cards data
    @nbr_urgent = Event.where(emergency_level: 'urgent').count
    @nbr_rent_rev = Event.where(description: 'révision de loyer').count
    @nbr_late_rent = Event.where(description: 'retard loyer').count
    @nbr_end_lease = Event.where(description: 'fin de bail').count

    # Graph data:
    @labels = []
    @data = []
    BalanceDay.all.each do |b|
      @labels << "#{b.day.day}/#{b.day.month}"
      @data << b.balance
    end
  end
end
