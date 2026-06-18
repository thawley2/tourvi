module Portal
  class SuggestionsController < BaseController
    def create
      tour = current_tour
      tour.suggestions.create!(suggestion_params.merge(client: @client))
      redirect_to portal_client_tour_path(@client.portal_token, tour), notice: "Suggestion sent to your agent."
    end

    private

    def suggestion_params
      params.require(:suggestion).permit(:address, :city, :beds, :baths, :price)
    end
  end
end
