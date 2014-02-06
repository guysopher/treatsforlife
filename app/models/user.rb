# coding: utf-8
class User

  include Mongoid::Document

  field :provider, type: String
  field :uid, type: String
  field :name, type: String
  field :nickname, type: String
  field :image, type: String
  field :email, type: String
  field :location, type: String
  field :token, type: String
  field :secret, type: String

  field :pets_history, type: Array
  field :current_pet, type: String

  #-------------#
  # auth_update #
  #-------------#
  def auth_update( auth )
    image_path = "https://graph.facebook.com/#{auth['info']['nickname'].presence || auth["uid"]}/picture?width=200&height=200"

    if self.name != auth["info"]["name"] or self.nickname != auth["info"]["nickname"] or self.image != image_path or self.email != auth["info"]["email"] or self.location != auth["info"]["location"]
      self.name     = auth["info"]["name"]
      self.nickname = auth["info"]["nickname"]
      self.image    = image_path
      self.email    = auth["info"]["email"]
      self.location = auth["info"]["location"]
      self.save!
    end
  end

  def auth_update_sso(user)
    image_path = "https://graph.facebook.com/#{user['username'].presence || user['uid']}/picture?width=200&height=200"
    if self.name != user['name'] or self.nickname != user['nickname'] or self.image != image_path or self.email != user['email'] or self.location != user['location']
      self.name     = user['name']
      self.nickname = user['nickname']
      self.image    = image_path
      self.email    = user['email']
      self.location = user['location']
      self.save!
    end
  end

  private

  #---------------------------#
  # self.create_with_omniauth #
  #---------------------------#
  def self.create_with_omniauth( auth )
    user = User.new
    user.provider = auth["provider"]
    user.uid      = auth["uid"]

    unless auth["info"].blank?
      user.name     = auth["info"]["name"]
      user.image    = auth["info"]["image"]
      user.email    = auth["info"]["email"]
      user.location = auth["info"]["location"]
    end

    unless auth["credentials"].blank?
      user.token  = auth['credentials']['token']
      user.secret = auth['credentials']['secret']
    end

    user.save!

    return user
  end

  def self.create_with_sso(uid, access_token)
    user = User.new
    user.provider = 'facebook'
    user.uid      = uid
    user.token  = access_token

    graph = Koala::Facebook::API.new(access_token)
    profile = graph.get_object('/me', :fields => 'name,location,email,username')
    image_path = "https://graph.facebook.com/#{profile['username'].presence || uid}/picture?width=200&height=200"
    user.name     = profile['name']
    user.nickname = profile['username']
    user.image    = "https://graph.facebook.com/#{profile['username'].presence || uid}/picture?width=200&height=200"
    user.email    = profile['email']
    user.location = profile['location']

    user.save!

    return user
  end



end
