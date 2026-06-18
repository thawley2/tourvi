module Portal
  class MessagesController < BaseController
    def create
      tour = current_tour
      if params.dig(:body).present?
        tour.messages.create!(sender_type: "client", sender_id: @client.id, body: params[:body])
      end
      respond_to do |format|
        format.turbo_stream { render turbo_stream: "" }
        format.html { redirect_to portal_client_tour_path(@client.portal_token, tour) }
      end
    end
  end
end
