class ExtendLoansOfInstallmentType < ActiveRecord::Migration[6.0]
   def change
      add_column :loans, :installment_type, :integer, :null => false, :default => 0
   end
end
