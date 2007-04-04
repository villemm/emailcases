class CreateDurations < ActiveRecord::Migration
  def self.up
	create_table :durations do |t|
		t.column :category, :string
	end
  end

  def self.down
	drop_table :durations
  end
end
