class ExtendLoansOfPeriod < ActiveRecord::Migration[6.0]
   def change
      add_column :loans, :period, :integer, :null => false, :default => 12
   end
end
