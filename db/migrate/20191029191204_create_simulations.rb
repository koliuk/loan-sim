class CreateSimulations < ActiveRecord::Migration[6.0]
  def self.up
      create_table :simulations do |t|
      	t.column :name, :string, :limit => 256, :null => false
      	t.column :loan_id, :integer
      end
   end

   def self.down
      drop_table :simulations
   end
end
