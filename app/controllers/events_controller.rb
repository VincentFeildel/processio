class EventsController < ApplicationController
  def index
    new_hash = {"late_rent" => "retard loyer", "end_of_lease" => "fin de bail", "rent_revision" => "révision de loyer"}
    @events=[]
    new_hash.each do |key, value|
      if params[key.to_sym] == "on"
        @events << Event.where("description = ?", value)
        @events = @events.flatten
      end
    end
    if @events == []
      @events = Event.all
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
  end

  def home
  end
end
