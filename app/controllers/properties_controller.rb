class PropertiesController < ApplicationController
  before_action :set_tour
  before_action :set_property, only: %i[edit update destroy]

  def new
    @property = @tour.properties.new
  end

  def create
    @property = @tour.properties.new(property_params)
    if @property.save
      redirect_to @tour, notice: "Property added."
    else
      redirect_to @tour, alert: @property.errors.full_messages.to_sentence
    end
  end

  def edit
  end

  def update
    if params.dig(:property, :position).present?
      @property.insert_at(params[:property][:position].to_i)
      head :ok
    elsif @property.update(property_params)
      redirect_to @tour, notice: "Property updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @property.destroy
    redirect_to @tour, notice: "Property removed."
  end

  private

  def set_tour
    @tour = current_agent.tours.find(params[:tour_id])
  end

  def set_property
    @property = @tour.properties.find(params[:id])
  end

  def property_params
    params.require(:property).permit(:address, :city, :beds, :baths, :price, :mls_id, :notes)
  end
end
