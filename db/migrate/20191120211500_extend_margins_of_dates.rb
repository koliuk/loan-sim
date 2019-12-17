class ExtendMarginsOfDates < ActiveRecord::Migration[6.0]
   def change
      add_column :interest_periods, :date_from, :date, :null => false, :default => Date.current
      add_column :interest_periods, :date_to, :date
   end
end
