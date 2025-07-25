class HotspotProfilesController < ApplicationController
  before_action :set_router
  before_action :set_profile, only: [:destroy]

  def index 
  end 

  def create 
    @profile = @router.hotspot_profiles.build(profile_params)
    
    if @profile.save
      if @profile.create_on_router
        redirect_to @router, notice: 'Hotspot profile was successfully created.'
      else
        @profile.destroy
        redirect_to @router, alert: 'Profile saved locally but failed to create on MikroTik device.'
      end
    else
      redirect_to @router, alert: build_error_message(@profile)
    end
  end

  def destroy
    if @profile.destroy
      redirect_to @router, notice: 'Hotspot profile was successfully removed.'
    else
      redirect_to @router, alert: 'Failed to remove hotspot profile.'
    end
  end

  def sync
    if @router.configuration_service.sync_hotspot_profiles
      redirect_to @router, notice: 'Hotspot profiles synced from MikroTik.'
    else
      redirect_to @router, alert: 'Failed to sync hotspot profiles from MikroTik.'
    end
  end

  private 

  def set_router
    @router = current_user.routers.find(params[:router_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to routers_path, alert: 'Router not found.'
  end

  def set_profile
    @profile = @router.hotspot_profiles.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to @router, alert: 'Hotspot profile not found.'
  end
  
  def profile_params
    params.require(:hotspot_profile).permit(:name, :rate_limit)
  end

  def build_error_message(profile)
    "Failed to create hotspot profile: #{profile.errors.full_messages.join(', ')}"
  end
end
