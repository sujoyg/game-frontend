class OpenIdController < ApplicationController
  include GameHelper

  skip_before_filter :authorize

  def connect
    response.headers['WWW-Authenticate'] = Rack::OpenID.build_header(
        identifier: 'https://www.appdirect.com/openid/id',
        required: ['email', 'fullname'],
        return_to: open_id_accept_url,
        realm: open_id_accept_url,
        method: 'GET')
    head 401
  end

  def accept
    response = request.env[Rack::OpenID::RESPONSE]
    redirect_to root_path unless response.present?

    case response.status
      when :success
        data = OpenID::SReg::Response.from_success_response(response)
        user = User.where(email: data['email']).first_or_initialize
        if data['fullname']
          user.name = data['fullname']
        end
        user.save!
        session[:user_id] = user.id

        reset_game
        redirect_to(session[:redirect_to] || home_path)
      when :failure
        flash[:error] = 'OpenId login failed.'
        redirect_to root_path
    end
  end
end
