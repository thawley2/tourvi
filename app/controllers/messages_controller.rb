class MessagesController < ApplicationController
  def create
    @tour = current_agent.tours.find(params[:tour_id])
    if params[:body].present?
      @tour.messages.create!(sender_type: "agent", sender_id: current_agent.id, body: params[:body])
    end
    respond_to do |format|
      # The model broadcasts the new bubble; the form just clears itself.
      format.turbo_stream { render turbo_stream: "" }
      format.html { redirect_to @tour }
    end
  end
end
