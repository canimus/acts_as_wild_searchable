class User < ActiveRecord::Base
  acts_as_wild_searchable
  attr_accessible :age, :last_name, :name
end
