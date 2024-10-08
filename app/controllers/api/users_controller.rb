module Api
  class UsersController < ApiController
    before_action :disable_terms_redirect, :only => [:details]
    before_action :setup_user_auth, :only => [:show, :index]
    before_action :authorize, :only => [:details, :gpx_files]

    authorize_resource :except => [:provision]
    skip_authorization_check :only => [:provision]

    load_resource :only => :show

    before_action :set_request_formats, :except => [:gpx_files]

    def index
      raise OSM::APIBadUserInput, "The parameter users is required, and must be of the form users=id[,id[,id...]]" unless params["users"]

      ids = params["users"].split(",").collect(&:to_i)

      raise OSM::APIBadUserInput, "No users were given to search for" if ids.empty?

      @users = User.visible.where(:id => ids).in_order_of(:id, ids)

      # Render the result
      respond_to do |format|
        format.xml
        format.json
      end
    end

    def show
      if @user.visible?
        # Render the result
        respond_to do |format|
          format.xml
          format.json
        end
      else
        head :gone
      end
    end

    def details
      @user = current_user
      # Render the result
      respond_to do |format|
        format.xml { render :show }
        format.json { render :show }
      end
    end

    def gpx_files
      @traces = current_user.traces.reload
      render :content_type => "application/xml"
    end

    def provision
      user = User.find_by(:auth_provider => "TDEI", :auth_uid => params[:auth_uid])

      if user
        user.email = params[:email]
        user.display_name = params[:display_name]

        if user.status != "active"
          user.activate
        end

        user.save
        return head :no_content
      end

      # TODO: temporary for TDEI auth transition:
      user = User.find_by(:email => params[:email])

      if user
        user.auth_provider = 'TDEI'
        user.auth_uid = params[:auth_uid]
        user.display_name = params[:display_name]

        if user.status != "active"
          user.activate
        end

        user.save
        return head :no_content
      end

      puts 'Create user'
      user = User.new()
      user.email = params[:email]
      user.email_valid = true
      user.display_name = params[:display_name]

      user.auth_provider = 'TDEI'
      user.auth_uid = params[:auth_uid]

      # Set a random password--TDEI identity services manage the password:
      user.pass_crypt = SecureRandom.base64(16)

      user.data_public = true
      user.description = '' if user.description.nil?
      user.creation_ip = request.remote_ip
      user.languages = http_accept_language.user_preferred_languages
      user.terms_agreed = Time.now.utc
      user.tou_agreed = Time.now.utc
      user.terms_seen = true
      user.auth_provider = nil
      user.auth_uid = nil
      user.activate
      user.save

      head :no_content
    end

    private

    def disable_terms_redirect
      # this is necessary otherwise going to the user terms page, when
      # having not agreed already would cause an infinite redirect loop.
      # it's .now so that this doesn't propagate to other pages.
      flash.now[:skip_terms] = true
    end
  end
end
