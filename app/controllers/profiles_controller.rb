class ProfilesController < ApplicationController
  def show
    @agent = current_agent
  end

  def edit
    @agent = current_agent
  end

  def update
    @agent = current_agent
    if @agent.update(profile_params)
      redirect_to profile_path, notice: "Profile saved."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:agent).permit(:name, :phone, :title, :brokerage, :license_number, :bio, :profile_color, :avatar)
  end
end
