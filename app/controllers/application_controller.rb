# coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authorize
  before_filter :reset_session_expires

  private

  #-----------#
  # authorize #
  #-----------#
  def authorize
    # セッション／トップコントローラ以外で
    if params[:controller] != "sessions" and params[:controller] != "top" and params[:controller] != 'pages'
      # 未ログインであればルートヘリダイレクト
      if session[:user_id].blank?
        # リクエストURL保管
        session[:request_url] = request.url
        redirect_to '/welcome' and return
      end
    end
  end

  #-----------------------#
  # reset_session_expires #
  #-----------------------#
  def reset_session_expires
    request.session_options[:expire_after] = 2.weeks
  end

  #--------------#
  # current_user #
  #--------------#
  def current_user
    @current_user ||= User.where( id: session[:user_id] ).first
  end
  helper_method :current_user

  def save_action(uid, uname, aid=nil, aname=nil, pid=nil, pname=nil, oid=nil, oname=nil)
    stam=1

    @action = Action.new({
                   uid:uid.to_s,
                   uname:uname.to_s,
                   aid:aid.to_s,
                   aname:aname.to_s,
                   pid:pid.to_s,
                   pname:pname.to_s,
                   uid:uid.to_s,
                   uname:uname.to_s,
                   oid:oid.to_s,
                   oname:oname.to_s,
                   t:(Time.now)
    })
    @action.save!
  end
  helper_method :save_action

  def send_sms

    unless (params['to'].nil?)
      require 'twilio-ruby'

      text = params['text'] || "Join the fun on Moment.me"

      @account_sid = 'AC30eea0dc1226e638714ca5228304993a'
      @auth_token = "011359ca5fb5532fb3ee9ea189cfd895"

      # set up a client to talk to the Twilio REST API
      @client = Twilio::REST::Client.new(@account_sid, @auth_token)

      @account = @client.account
      begin
        @message = @account.sms.messages.create({:from => '+12508003690', :to => '+' + params['to'], :body => text})

        #message was successful - record to analytics
        text.scan(/\w+/).each do |ref|
        end
      rescue Exception => e
        @message = ''
      end
      render :text => @message
    end
  end
  helper_method :send_sms


end
