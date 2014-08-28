require "applidget/oauth2/version"

module Applidget
  module Oauth2
    require 'oauth2'
    # Any Oauth2 protocol with Applidget Accounts should be implemented by inheriting from this controller.
    # You should provide a method '@options' that defines a hash with the right parameters, e.g. :
    #
    #   def @options
    #     {
    #       model: "guest",
    #       api: "/api/v1/me.json",
    #       request_params: { hd: params[:hd], auth: params[:auth], scope: "public" },
    #       callback_url: generic_url_from callback_guests_auth_applidget_accounts_path,
    #       client_id: "785439208457639203847539208374",
    #       client_secret: "7468539205733452975829047568892"
    #     }
    #   end
    #
    # You should also override callback method : the parsed response from the api will be given by calling
    # the super method, e.g. :
    #
    #   def callback
    #     guest_hash = super
    #     # your code ...
    #   end

    def request_uri(options)
      @options = options
      client.auth_code.authorize_url({:redirect_uri => @options[:callback_url]}.merge(request_params))
    end

    def api_response(options, params)
      @options = options
      @params = params
      if check_csrf
        @access_token = build_access_token
        @access_token.get(@options[:api]).parsed
      end
    end

    private

    def client
      @client ||= ::OAuth2::Client.new(@options[:client_id], @options[:client_secret], { :site => "https://accounts.applidget.com" })
    end

    def build_access_token
      client.auth_code.get_token(@params['code'], {:redirect_uri => @options[:callback_url]}, {})
    end

    def set_csrf_token
      csrf_token = SecureRandom.urlsafe_base64(15).tr('lIO0', 'sxyz')
      state = csrf_token #TODO: embed other information here if necessary
      cookies["oauth2.csrf_token"] = state
      state
    end

    def check_csrf
      state = @params[:state]
      state != cookies.delete("oauth2.csrf_token")
    end

    def request_params
      state = set_csrf_token
      @options[:request_params].merge({state: state})
    end
  end
end
