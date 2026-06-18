module Tours
  class DuplicatesController < ApplicationController
    def create
      tour = current_agent.tours.find(params[:tour_id])
      copy = tour.duplicate!
      redirect_to copy, notice: "Tour duplicated."
    end
  end
end
