module Offcourse
  class DiscourseSite < ActiveRecord::Base
    self.table_name = "discourse_sites"

    serialize :meta, JSON


  end
end
