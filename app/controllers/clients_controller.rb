class ClientsController < ApplicationController
  before_action :set_client, only: %i[show edit update destroy]

  def index
    @clients = current_agent.clients.order(:name)
  end

  def show
    @tours = @client.tours.order(tour_date: :desc)
  end

  def new
    @client = current_agent.clients.new
  end

  def create
    @client = current_agent.clients.new(client_params)
    if @client.save
      redirect_to @client, notice: "Client added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @client.update(client_params)
      redirect_to @client, notice: "Client updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @client.destroy
    redirect_to clients_path, notice: "Client removed."
  end

  private

  def set_client
    @client = current_agent.clients.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:name, :email, :phone, :notes, :stage, :budget, :pre_approved, :pre_approval_amount)
  end
end
