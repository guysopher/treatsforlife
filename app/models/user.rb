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

end
