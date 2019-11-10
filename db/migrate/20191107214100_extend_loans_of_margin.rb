class ExtendLoansOfMargin < ActiveRecord::Migration[6.0]
  def self.up
      create_table :interest_periods do |t|
         t.column :loan_id, :integer, :null => false
         t.column :interest, :decimal, :precision => 8, :scale => 2, :null => false
      end
   end

   def self.down
      drop_table :interest_periods
   end

end
