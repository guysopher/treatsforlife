class Action
  include Mongoid::Document
  field :uid, type: String
  field :uname, type: String
  field :aid, type: String
  field :aname, type: String
  field :pid, type: String
  field :pname, type: String
  field :oid, type: String
  field :oname, type: String
  field :t, type: Time
end
