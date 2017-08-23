class PagesController < ApplicationController
  def home
    @user = current_user
    @percentage_done = (Event.where(to_do: false).count.fdiv(Event.all.count)*100).round
    @nbr_urgent = Event.where(emergency_level: 'urgent').count
    @nbr_rent_rev = Event.where(description: 'révision de loyer').count
    @nbr_late_rent = Event.where(description: 'retard loyer').count
    @nbr_end_lease = Event.where(description: 'fin de bail').count
  end
end
