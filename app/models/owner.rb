class Owner
  include Mongoid::Document
  field :name, type: String
  field :about, type: String
  field :adopted_pets, type: Array
  field :current_pet, type: String

end
