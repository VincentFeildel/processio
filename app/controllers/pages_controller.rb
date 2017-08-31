class PagesController < ApplicationController
  def home
    @user = current_user

    #Cards data

    @nbr_rent_rev = Event.where(description: 'révision de loyer', to_do: true).count
    @nbr_late_rent = Event.where(description: 'retard loyer', to_do: true).count
    @nbr_end_lease = Event.where(description: 'fin de bail', to_do: true).count
    @nbr_total = Event.where(to_do: true).count

    @nbr_urgent = Event.where(emergency_level: 'urgent', to_do: true).count
    @nbr_urgent_prog = Event.where(emergency_level: 'urgent', to_do: true).count
    @nbr_urgent_t = Event.where(emergency_level: 'urgent').count

    # Circular progress bar data:
    @percentage_done = ((@nbr_urgent.fdiv(@nbr_urgent_t) + @nbr_urgent_prog.fdiv(@nbr_urgent_t*2))*100).round

    @percentage_finished = (((@nbr_urgent_t - @nbr_urgent).fdiv(@nbr_urgent_t)) * 100).round
    p = 0
    Event.where(status: 'tenant_to_notify', emergency_level: 'urgent', to_do: true).each do |e|
      p += 1 if e.description != 'retard loyer'
    end
    @percentage_progress = (p.fdiv(@nbr_urgent_t)*100).round
    @percentage_done = (@percentage_progress/2) + @percentage_finished

    # Graph data:
    @labels = []
    @data_overdue = []
    @data_rents = []
    BalanceDay.all.each do |b|
      @labels << "#{b.day.day}/#{b.day.month}"
      @data_overdue << b.balance
      @data_rents << b.all_rents
    end
  end
end
