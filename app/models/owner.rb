class Owner
  include Mongoid::Document
  field :name, type: String
  field :pets, type: Array
  field :adopted_pets, type: Array
  field :current_pet, type: String

end
