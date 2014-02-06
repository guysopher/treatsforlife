class Pet
  include Mongoid::Document


  field :name, type: String
  field :breed, type: String
  field :color, type: String
  field :age, type: String
  field :size, type: String
  field :gender, type: String
  field :info, type: String
  field :story, type: String
  field :owner_id, type: String
  field :videos, type: Array
  field :photos, type: Array

  belongs_to :user
end
