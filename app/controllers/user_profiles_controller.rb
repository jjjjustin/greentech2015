class UserProfilesController < ApplicationController

  load_and_authorize_resource
  
  def new
    @user_profile = UserProfile.new
  end

  def create
    @user_profile = UserProfile.new(user_profile_params)
    @user_profile.user = current_user

    if @user_profile.save
      flash[:success] = "Profile saved."
      redirect_to ideas_path
    else
      flash[:danger] = "There was a problem saving your info."
      render :new
    end
  end

  def edit
    @user_profile = UserProfile.find(params[:id])
  end

  def update
    @user_profile = UserProfile.find(params[:id])

    if @user_profile.update_attributes(user_profile_params)
      flash[:success] = "Profile updated."
      redirect_to ideas_path
    else
      flash[:danger] = "There was a problem saving your info."
      render :edit
    end
  end


  private

    def user_profile_params
      params.require(:user_profile).permit(:profession, :linkedin, :location)
    end
end
