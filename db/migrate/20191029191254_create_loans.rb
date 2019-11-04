class CreateLoans < ActiveRecord::Migration[6.0]
  def self.up
      create_table :loans do |t|
      	 t.column :simulation_id, :integer, :null => false
         t.column :amount, :decimal, :precision => 11, :scale => 2, :null => false
         t.column :currency, :string, :null => false, :length => 3
      end
   end

   def self.down
      drop_table :loans
   end
end
