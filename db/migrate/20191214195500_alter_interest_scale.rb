class AlterInterestScale < ActiveRecord::Migration[6.0]
    def self.up
        change_column :interest_periods, :interest, :decimal, :precision => 8, :scale => 6, :null => false
    end

    def self.down
        change_column :interest_periods, :interest,  :decimal, :precision => 8, :scale => 2, :null => false
    end
end