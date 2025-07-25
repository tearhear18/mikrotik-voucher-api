class HotspotProfilesController < ApplicationController
  def index 
  end 

  def create 
    @router = current_user.routers.find(params[:router_id])
    @profile = @router.hotspot_profiles.new(profile_param)
    if @profile.save
      redirect_to @router, notice: 'Hotspot profile was successfully created.'
    else
      redirect_to @router, alert: 'Failed to create hotspot profile.'
    end
  end

  private 
  
  def profile_param
    params.require(:hotspot_profile).permit(:name, :rate)
  end
end
