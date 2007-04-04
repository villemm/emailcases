require 'ajax_scaffold'

class Person < ActiveRecord::Base
        has_many :tasks

end
