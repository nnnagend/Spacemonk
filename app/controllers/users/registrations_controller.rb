class Users::RegistrationsController < Devise::RegistrationsController

	private

	def sign_up_params
		params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password, :birth_date, :is_female, :personal_website, :city, :state, :country, :location, :remember_me, :avatar, :avatar_cache)
	end

	def account_update_params
		params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password, :birth_date, :personal_website, :city, :state, :country, :location, :remember_me, :avatar, :avatar_cache, :remove_fb_image, :remove_avatar)
	end

	# If provider if FB dont require password to update user information
	# Remove Fb_Image logic
	def update_resource(resource, params)
    if current_user.provider == "facebook"
      params.delete("current_password")
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end

		if params[:remove_fb_image]=='1'
			current_user.update_attributes(:fb_image => nil)
			return new_user_registration_url
		end

		new_user_registration_url
	end
end
