class LeasesController < ApplicationController
  before_action :set_lease, only: [:show]
  def index
    @leases = Lease.all
  end

  def new
    @lease = Lease.new
  end

  def show
    @event = Event.new
  end

  private

    def set_lease
      @lease = Lease.find(params[:id])
    end
end
