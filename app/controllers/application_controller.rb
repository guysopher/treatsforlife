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
    if params[:controller] != "sessions" and params[:controller] != "top"
      # 未ログインであればルートヘリダイレクト
      if session[:user_id].blank?
        # リクエストURL保管
        session[:request_url] = request.url

        redirect_to :root and return
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

end
