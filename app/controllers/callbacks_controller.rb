class CallbacksController < Devise::OmniauthCallbacksController
    def facebook
  		auth = env["omniauth.auth"]

  		@user = User.find_for_facebook_oauth(request.env["omniauth.auth"],current_user)
  		if @user.persisted?
  		  flash[:notice] = I18n.t "devise.omniauth_callbacks.success"
  		  sign_in_and_redirect @user, :event => :authentication
  		else
  		  session["devise.twitter_uid"] = request.env["omniauth.auth"]
  		  redirect_to new_user_registration_url
  		end
    end
	def google_oauth2
        logger.debug "google_kemal"
        @user = User.from_omniauth(request.env["omniauth.auth"])
        logger.debug {@user.uid}
        logger.debug "google_kemal"
        sign_in_and_redirect @user
    end
	def linkedin
        @user = User.from_omniauth(request.env["omniauth.auth"])
        sign_in_and_redirect @user
    end
	def twitter
    logger.debug "kemal2"
		auth = env["omniauth.auth"]

    logger.debug auth
		@user = User.find_for_twitter_oauth(request.env["omniauth.auth"],current_user)
		if @user.persisted?
      logger.info "kemal5"
		  flash[:notice] = I18n.t "devise.omniauth_callbacks.success"
      logger.info "kemal72"
      logger.info @user.uid.to_s
		  sign_in_and_redirect @user, :event => :authentication
		else
      logger.info "kemal6"
		  session["devise.twitter_uid"] = request.env["omniauth.auth"]
		  redirect_to new_user_registration_url
		end
	end
end