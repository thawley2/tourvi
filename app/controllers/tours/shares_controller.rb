module Tours
  class SharesController < ApplicationController
    def show
      @tour = current_agent.tours.find(params[:tour_id])
      @client = @tour.client
    end
  end
end
