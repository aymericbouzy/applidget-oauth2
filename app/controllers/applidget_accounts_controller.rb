require 'oauth2'

class ApplidgetAccountsController < ActionController::Base
  # Any Oauth2 protocol with Applidget Accounts should be implemented by inheriting from this controller.
  # You should provide a method 'options' that defines a hash with the right parameters, e.g. :
  #
  #   def options
  #     {
  #       model: "guest",
  #       api: "/api/v1/me.json",
  #       request_params: { hd: params[:hd], auth: params[:auth], scope: "public" },
  #       callback_url: generic_url_from callback_guests_auth_applidget_accounts_path
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

  before_filter :check_csrf, :only => [:callback]

  def index
    redirect_to client.auth_code.authorize_url({:redirect_uri => options[:callback_url]}.merge(request_params))
  end

  def callback
    @access_token = build_access_token
    @access_token.get(options[:api]).parsed
  end

  private

  def client
    @client ||= ::OAuth2::Client.new(options[:client_id], options[:client_secret], { :site => options[:provider_host] })
  end

  def build_access_token
    client.auth_code.get_token(params['code'], {:redirect_uri => options[:callback_url]}, {})
  end

  def set_csrf_token
    csrf_token = SecureRandom.urlsafe_base64(15).tr('lIO0', 'sxyz')
    state = csrf_token #TODO: embed other information here if necessary
    cookies["oauth2.csrf_token"] = state
    state
  end

  def check_csrf
    state = params[:state]
    if state != cookies.delete("oauth2.csrf_token")
      render :text => "csrf request detected. More info at: http://en.wikipedia.org/wiki/Cross-site_request_forgery", :status => :unauthorized
    end
  end

  def request_params
    state = set_csrf_token
    options[:request_params].merge({state: state})
  end
end
