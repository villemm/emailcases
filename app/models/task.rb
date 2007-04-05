require 'ajax_scaffold'

class Task < ActiveRecord::Base
  	belongs_to :person, :foreign_key => "person_id"
        belongs_to :duration, :foreign_key => "duration_id"

  @scaffold_columns = [ 
      AjaxScaffold::ScaffoldColumn.new(self, { :name => "name" }),
#      AjaxScaffold::ScaffoldColumn.new(self, { :name => "firstname", :eval => "task.person.firstname", :sort_sql => "firstname" }),
      AjaxScaffold::ScaffoldColumn.new(self, { :name => "lastname", :eval => "task.person.lastname", :sort_sql => "lastname" }),
      AjaxScaffold::ScaffoldColumn.new(self, { :name => "category", :eval => "task.duration.category", :sort_sql => "category" }),
      AjaxScaffold::ScaffoldColumn.new(self, { :name => "updated_on"}),
      AjaxScaffold::ScaffoldColumn.new(self, { :name => "created_on"})
    ]
end
