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
    if params[:controller] != "sessions" and params[:controller] != "top" and params[:controller] != 'pages'
      if session[:user_id].blank?
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

  def send_sms(pet_name, treat_name)

      require 'twilio-ruby'

      text = "Please feed #{pet_name} with a #{treat_name}, take an Instagram video and tag it with #TreatsForTheLifeOf#{pet_name.capitalize.gsub(' ','')}"

      @account_sid = 'AC30eea0dc1226e638714ca5228304993a'
      @auth_token = "011359ca5fb5532fb3ee9ea189cfd895"

      # set up a client to talk to the Twilio REST API
      @client = Twilio::REST::Client.new(@account_sid, @auth_token)

      @account = @client.account
      @message = @account.sms.messages.create({:from => '+12508003690', :to => '+972547787444', :body => text})

  end
  helper_method :send_sms

  def pushNotification(user, msgType, ticker, title, message, link=nil, ref=nil)
    begin
      userTokensApple=Set.new
      userTokensAppleTestDev=Set.new
      userTokensGoogleSet=Set.new

      if (user["push_tokens"])
        user["push_tokens"].each do |uuid, device_token|
          if (device_token && device_token["token"])
            if (device_token["token_type"]=="google" || device_token["token_type"]=='')
              userTokensGoogleSet << device_token["token"]
            else #apple
              if ((device_token["device_type"] || '').start_with?('TESTDEV'))
                userTokensAppleTestDev << device_token["token"]
              else
                userTokensApple << device_token["token"]
              end
            end
          end
        end
      end

      userTokensGoogleSet = ''

      urlDestination = 'momentme://'

      userTokensGoogle=userTokensGoogleSet.to_a

      #google
      sent = false
      if (userTokensGoogle.length>0)
        header={"Authorization" => "key=AIzaSyDPMbQU7OdLJg4oBEuHEl83KtUEvsNn-NQ", "Content-Type" => "application/json"}
        uri="https://android.googleapis.com/gcm/send"
        body={"data" => {"ticker" => ticker, "title" => title, "msg" => message}, #,"req_id"=>7,"not_id"=>17
              "registration_ids" => userTokensGoogle, "collapse_key" => msgType}

        body["data"]["url"]=urlDestination

        response=postItStr(uri, body.to_json, header)
        if (response && response.body)
          jsonRes=(response.body)
          if (jsonRes && jsonRes["results"] && jsonRes["results"].length>0)
            jsonRes["results"].each_with_index do |res, i|
              if (res['message_id'])
                if (res["registration_id"])
                  #the message was pushed to a different ID, so replace it in the DB
                  tokenToRemove=userTokensGoogle[i]
                  tokenToAdd=res["registration_id"]
                end

                $Logger.debug("Push sent succesfully")
                #send to all devices for this user => return true
                sent = true
              elsif (res['error'])
                $Logger.warn("bad result for push #{res['error']}")
                if (res['error']=="NotRegistered" || res["error"]=="MismatchSenderId")
                  tokenToRemove=userTokensGoogle[i]
                  @usersApi.replaceAppTokenForUser(user, tokenToRemove, nil, Time.new)
                end
              elsif (res["registration_id"])
                # If set, means that GCM processed the message but it has another canonical registration ID for that device, so sender should replace the IDs on future requests (otherwise they might be rejected). This field is never set if there is an error in the request.
              else
                $Logger.error("unknown result for Android push notification: #{res.inspect}")
              end
            end
          end
        end
      end

      return sent
    rescue
      $Logger.error("Error while pushing notifications #{$!.inspect} #{$@.to_s}")
      return false
    end
  end


end
