class EventsController < ApplicationController
   before_action :set_event, only: [:show]
  def index
    @total_events = Event.all
    @urgent_events = Event.where("emergency_level = ?", "urgent")
    @late_rent = Event.where("description = ?", "retard loyer")
    @end_of_lease = Event.where("description = ?", "fin de bail")
    @rent_revision = Event.where("description = ?", "révision de loyer")
    @events=[]
    landing = true
    # Add a condition if you come from searchbar
    unless params[:search].blank?
      @total_events.each do |event|
        @events << event if event.lease.owner_name.downcase.include?(params[:search].downcase)
      end
    else
      # Create a hash with the params and the human redable corresponding value
      new_hash = {"late_rent" => "retard loyer", "end_of_lease" => "fin de bail", "rent_revision" => "révision de loyer"}
      # Iterate on hash to add the events ot the @events array if they are selected
      new_hash.each do |key, value|
        if params[key.to_sym] == "on"
          # Add a condition to check if the emergency level is urgent
          @events << Event.where("description = ?", value)
          @events = @events.flatten
          landing = false
        end
      end
        # Return all events if nothin is selected and check if emergency level is urgent
      if @events == [] && !params.values.include?("on")
        @events = Event.all
      end
    end

    # adding some code to have checkbox's checked = true directly and adapt afterwards
    if landing && !params.values.include?("on")
      @late_rent_checked = true
      @end_of_lease_checked = true
      @rent_revision_checked = true
    else
      params[:late_rent] == "on" ? @late_rent_checked = true : @late_rent_checked = false
      params[:end_of_lease] == "on" ? @end_of_lease_checked = true : @end_of_lease_checked = false
      params[:rent_revision] == "on" ? @rent_revision_checked = true : @rent_revision_checked = false
    end

    # sorting the events array
    pivot = @events
    @events = pivot.sort_by do |event|
      event.end_date
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def index_urgent
    @total_events = Event.all
    @urgent_events = Event.where("emergency_level = ?", "urgent")
    @late_rent = Event.where("description = ? AND emergency_level = ?", "retard loyer", "urgent")
    @end_of_lease = Event.where("description = ? AND emergency_level = ?", "fin de bail", "urgent")
    @rent_revision = Event.where("description = ? AND emergency_level = ?", "révision de loyer", "urgent")
    # Create a hash with the params and the human redable corresponding value
    new_hash = {"late_rent" => "retard loyer", "end_of_lease" => "fin de bail", "rent_revision" => "révision de loyer"}
    @events=[]
    landing = true

    # Iterate on hash to add the events ot the @events array if they are selected
    new_hash.each do |key, value|
      if params[key.to_sym] == "on"
        # Add a condition to check if the emergency level is urgent
        @events << Event.where("description = ? AND emergency_level = ?", value, "urgent")
        @events = @events.flatten
        landing = false
      end
    end
      # Return all events if nothin is selected and check if emergency level is urgent
    if @events == [] && !params.values.include?("on")
      @events = Event.where("emergency_level = ?", "urgent")
    end

    # adding some code to have checkbox's checked = true directly and adapt afterwards
    if landing && !params.values.include?("on")
      @late_rent_checked = true
      @end_of_lease_checked = true
      @rent_revision_checked = true
    else
      params[:late_rent] == "on" ? @late_rent_checked = true : @late_rent_checked = false
      params[:end_of_lease] == "on" ? @end_of_lease_checked = true : @end_of_lease_checked = false
      params[:rent_revision] == "on" ? @rent_revision_checked = true : @rent_revision_checked = false
    end

    # sorting the events array
    pivot = @events
    @events = pivot.sort_by do |event|
      event.end_date
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
      format.pdf do
        render pdf: "letter"
      end
    end
    @event.update(status: (@event.status == 'owner_to_contact' ?  'owner_contacted' : 'tenant_notified'))
  end

  def mail
    @event = Event.find(params[:event_id])
    # Instruction to get params and fill it in a new mail instance and send it
    if @event.status == 'owner_to_contact'
      EventMailer.notify_owner(@event, params[:response]).deliver_now
      @event.update(status: 'owner_contacted')
    else
      EventMailer.notify_tenant(@event, params[:response]).deliver_now
      @event.update(status: 'tenant_notified')
    end
    redirect_to event_path(@event)
  end

  def home
  end

  private
  def set_event
     @event = Event.find(params[:id])
  end
end
