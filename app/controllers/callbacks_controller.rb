class CallbacksController < Devise::OmniauthCallbacksController
    def facebook
        @user = User.from_omniauth(request.env["omniauth.auth"])
        sign_in_and_redirect @user
    end
	def google_oauth2
        @user = User.from_omniauth(request.env["omniauth.auth"])
        sign_in_and_redirect @user
    end
	def linkedin
        @user = User.from_omniauth(request.env["omniauth.auth"])
        sign_in_and_redirect @user
    end
	def twitter
		auth = env["omniauth.auth"]

		@user = User.find_for_twitter_oauth(request.env["omniauth.auth"],current_user)
		if @user.persisted?
		  flash[:notice] = I18n.t "devise.omniauth_callbacks.success"
		  sign_in_and_redirect @user, :event => :authentication
		else
		  session["devise.twitter_uid"] = request.env["omniauth.auth"]
		  redirect_to new_user_registration_url
		end
	end
end