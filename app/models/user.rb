class User < ActiveRecord::Base
	mount_uploader :avatar, AvatarUploader
  	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable, :timeoutable, :omniauthable, :omniauth_providers => [:facebook]

    # User Avatar Validation
  	validates_integrity_of  :avatar
  	validates_processing_of :avatar
		validates_presence_of :first_name, :last_name, :email
		validates_presence_of :password, :on => :create
		validates_presence_of :first_name, :last_name, :with => /^[-\w\._@]+$/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_@"
		validates_length_of :password, :minimum => 6, :allow_blank => true

    # Use attribute accessor to call gender instead of is_female
    attr_accessor :gender, :remove_fb_image

	GENDER_TYPES = [ ["Male","0"], [ "Female","1" ] ]

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      Rails.logger.info "FB Info : " + auth.info.inspect
      Rails.logger.info "FB Raw Info : " + auth.extra.raw_info.inspect
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      username = auth.info.name.split(' ')
      user.first_name = username[0]   # assuming the user model has a name
      user.last_name = username[username.length - 1]
      user.birth_date = Date.strptime(auth.extra.raw_info.birthday,'%m/%d/%Y')
      user.fb_image = auth.info.image # assuming the user model has an image
			user.is_female = gender_setter(auth.extra.raw_info.gender)

			# to get address we need to use Geocoder api
			full_address = Geokit::Geocoders::GoogleGeocoder.geocode(auth.info.location)
			user.city = full_address.state_name || ""
			user.state = full_address.city || ""
			user.country = full_address.country || ""
    end
  end

	private
  def avatar_size_validation
    errors[:avatar] << "should be less than 500KB" if avatar.size > 0.5.megabytes
  end

  def self.gender_setter(gender)
    if gender == 'male'
      return false
    else
      return true
    end
  end

	def self.lookup_ip_information(ip)
    location = Geokit::Geocoders::GeoPluginGeocoder.geocode(ip)
    puts location.full_address
    lat = location.lat
    lng = location.lng
		puts lat
		puts lng
  end

end
