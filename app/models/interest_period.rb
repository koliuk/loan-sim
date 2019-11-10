class InterestPeriod < ApplicationRecord
    belongs_to :loan

    validates_presence_of :interest, message: "Can't be blank"
    validates :interest, numericality: {message: "Should be a number"}
    validates :interest, numericality: {greater_than_or_equal_to: 0.00, message: "Should be >= 0.00"}
    validates :interest, numericality: {less_than_or_equal_to: 99.999999, message: "Should be <= 99.999999"}
    validates :interest, format: { with: /\A\d{0,2}(\.\d{0,6})?\z/ , message: "Should be in format: xx.xxxxxx"}
    
end