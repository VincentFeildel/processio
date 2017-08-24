class EventsController < ApplicationController
   before_action :set_event, only: [:show]
  def index
    # Create a hash with the params and the human redable corresponding value
    @total_events = Event.all
    @urgent_events = Event.where("emergency_level = ?", "urgent")
    @late_rent = Event.where("description = ?", "retard loyer")
    @end_of_lease = Event.where("description = ?", "fin de bail")
    @rent_revision = Event.where("description = ?", "révision de loyer")
    new_hash = {"late_rent" => "retard loyer", "end_of_lease" => "fin de bail", "rent_revision" => "révision de loyer"}
    @events=[]
    # Iterate on hash to add the events ot the @events array if they are selected
    new_hash.each do |key, value|
      if params[key.to_sym] == "on"
        # Add a condition to check if the emergency level is urgent
        @events << Event.where("description = ?", value)
        @events = @events.flatten
      end
    end
      # Return all events if nothin is selected and check if emergency level is urgent
    if @events == [] && !params.values.include?("on")
      @events = Event.all
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def index_urgent
    # Create a hash with the params and the human redable corresponding value
    @total_events = Event.all
    @urgent_events = Event.where("emergency_level = ?", "urgent")
    @late_rent = Event.where("description = ? AND emergency_level = ?", "retard loyer", "urgent")
    @end_of_lease = Event.where("description = ? AND emergency_level = ?", "fin de bail", "urgent")
    @rent_revision = Event.where("description = ? AND emergency_level = ?", "révision de loyer", "urgent")
    new_hash = {"late_rent" => "retard loyer", "end_of_lease" => "fin de bail", "rent_revision" => "révision de loyer"}
    @events=[]
    # Iterate on hash to add the events ot the @events array if they are selected
    new_hash.each do |key, value|
      if params[key.to_sym] == "on"
        # Add a condition to check if the emergency level is urgent
        @events << Event.where("description = ? AND emergency_level = ?", value, "urgent")
        @events = @events.flatten
      end
    end
      # Return all events if nothin is selected and check if emergency level is urgent
    if @events == [] && !params.values.include?("on")
      @events = Event.where("emergency_level = ?", "urgent")
    end
    respond_to do |format|
      format.html
      format.js
    end
  end


  def show
    @comment = Comment.new
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
