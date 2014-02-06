# coding: utf-8
class SessionsController < ApplicationController
  #----------#
  # callback #
  #----------#
  def callback
    auth = request.env["omniauth.auth"]
    user = User.where( provider: auth["provider"], uid: auth["uid"] ).first || User.create_with_omniauth( auth )
    user.auth_update( auth )

    session[:user_id] = user.id

    unless session[:request_url].blank?
      redirect_to session[:request_url]
      session[:request_url] = nil
      return
    end

    redirect_to :root
  end

  def api_callback
    user = User.where( provider: 'facebook', uid: params[:uid]).first || User.create_with_sso(params[:uid], params[:access_token])
    user.auth_update_sso(user)
    session[:user_id] = user.id
    render :json => user
  end

  #---------#
  # destroy #
  #---------#
  def destroy
    session[:user_id] = nil

    redirect_to :root
  end

  #---------#
  # failure #
  #---------#
  def failure
    render text: "<span style='color: red;'>Auth Failure</span>"
  end
end
