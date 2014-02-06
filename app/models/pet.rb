class Pet
  include Mongoid::Document
  field :name, type: String
  field :breed, type: String
  field :age, type: Integer
  field :size, type: Integer
  field :gender, type: Boolean
  field :owner_id, type: Integer
  field :videos, type: Array
  field :photos, type: Array
end
