class CreateTasks < ActiveRecord::Migration
  def self.up
	create_table :tasks do |t|
		t.column :name, :string
		t.column :duration_id, :integer, :value => 1
		t.column :person_id, :integer, :value => 1
	end
  end

  def self.down
	drop_table :tasks
  end
end
