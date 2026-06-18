module Tours
  class RecapsController < ApplicationController
    def show
      @tour = current_agent.tours.find(params[:tour_id])
    end
  end
end
