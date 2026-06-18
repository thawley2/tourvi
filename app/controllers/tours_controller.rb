class ToursController < ApplicationController
  before_action :set_tour, only: %i[show edit update destroy]

  def show
    @properties = @tour.properties.to_a
    @property = Property.new
    @messages = @tour.messages.order(:created_at)
    @suggestions = @tour.suggestions.order(:created_at)
  end

  def new
    @tour = current_agent.tours.new(client_id: params[:client_id], tour_date: params[:date])
  end

  def create
    @tour = current_agent.tours.new(tour_params)
    if @tour.save
      redirect_to @tour, notice: "Tour created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @tour.update(tour_params)
      redirect_back fallback_location: @tour, notice: "Tour updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tour.destroy
    redirect_to root_path, notice: "Tour deleted."
  end

  private

  def set_tour
    @tour = current_agent.tours.find(params[:id])
  end

  def tour_params
    params.require(:tour).permit(:name, :client_id, :tour_date, :tour_time, :status, :post_notes)
  end
end
