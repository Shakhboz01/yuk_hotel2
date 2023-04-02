class ApplicationRecord < ActiveRecord::Base
  include RansackableAttributes

  self.abstract_class = true
  primary_abstract_class
end
