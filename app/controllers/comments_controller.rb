class CommentsController < ApplicationController
  before_action :set_event, only: [:create]

  def create
    @comment = Comment.new(comment_params)
    @comment.event = @event
    @comment.save
    redirect_to event_path(@event)
  end

private
  def set_event
      @event = Event.find(params[:event_id])
  end
  def comment_params
      params.require(:comment).permit(:content)
  end
end
