class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
		 :omniauthable, :omniauth_providers => [:facebook, :google_oauth2, :twitter, :linkedin]

  def self.from_omniauth(auth)
    uid = auth.uid
    provider = auth.provider
      where(provider: provider, uid: uid).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
      end
  end
  
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.uid + "@facebook.com").first
      if registered_user
        return registered_user
      else

        user = User.create(provider:auth.provider,
                            uid:auth.uid,
                            email:auth.uid+"@facebook.com",
                            password:Devise.friendly_token[0,20],
                          )
      end

    end
  end
  
  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    logger.info "kemal3"
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    logger.info "kemal4"
    if user
      return user
    else
      registered_user = User.where(:email => auth.uid + "@twitter.com").first
      logger.info "user"
      if registered_user
        logger.debug "registered"
        return registered_user
      else
        logger.debug "new user"
        user = User.create(provider:auth.provider,
                            uid:auth.uid,
                            email:auth.uid+"@twitter.com",
                            password:Devise.friendly_token[0,20],
                          )
      end

    end
  end
  
end
