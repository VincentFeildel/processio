class EventsController < ApplicationController
   before_action :set_event, only: [:show]
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

  def letter
    @event = Event.find(params[:event_id])
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "letter"
      end
    end
  end

  def owner_contacted
    @event = Event.find(params[:event_id])
    @event.update(status: "owner_contacted")
    redirect_to event_path(@event)
  end
  def tenant_notified
    @event = Event.find(params[:event_id])
    @event.update(status: "tenant_notified")
    redirect_to event_path(@event)
  end

  def home
  end

  private
  def set_event
     @event = Event.find(params[:id])
  end
end
