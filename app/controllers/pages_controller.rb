class PagesController < ApplicationController
  def home
    @user = current_user
    @percentage_done = (Event.where(to_do: false).count.fdiv(Event.all.count)*100).round
  end
end
