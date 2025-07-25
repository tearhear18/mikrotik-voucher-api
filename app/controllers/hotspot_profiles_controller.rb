class HotspotProfilesController < ApplicationController
  def index 
  end 

  def create 
    @router = current_user.routers.find(params[:router_id])
    @profile = @router.hotspot_profiles.new(profile_param)
    if @profile.save
      if @profile.create_on_router
        redirect_to @router, notice: 'Hotspot profile was successfully created.'
      else
        @profile.destroy
        redirect_to @router, alert: 'Profile saved locally but failed to create on MikroTik device.'
      end
    else
      redirect_to @router, alert: 'Failed to create hotspot profile.'
    end
  end

  def destroy
    @router = current_user.routers.find(params[:router_id])
    @profile = @router.hotspot_profiles.find(params[:id])
    if @profile.destroy
      redirect_to @router, notice: 'Hotspot profile was successfully removed.'
    else
      redirect_to @router, alert: 'Failed to remove hotspot profile.'
    end
  end

  def sync
    @router = current_user.routers.find(params[:router_id])
    if @router.configuration_service.sync_hotspot_profiles
      redirect_to @router, notice: 'Hotspot profiles synced from MikroTik.'
    else
      redirect_to @router, alert: 'Failed to sync hotspot profiles from MikroTik.'
    end
  end

  private 
  
  def profile_param
    params.require(:hotspot_profile).permit(:name, :rate_limit)
  end
end
