require 'money'

class Loan < ApplicationRecord
    has_one :simulation
    
    has_many :margins, class_name: "InterestPeriod", dependent: :destroy
    accepts_nested_attributes_for :margins, reject_if: proc { |attr| attr[:id].blank? }

    validates_presence_of :currency_amount
    validates_presence_of :currency, message: "Can't be blank"
    validates_presence_of :amount, message: "Can't be blank"
    validates :amount, numericality: {message: "Should be a number"}
    validates :amount, numericality: {greater_than_or_equal_to: 1000.00, message: "Should be >= 1000.00"}
    validates :amount, numericality: {less_than_or_equal_to: 999999999.99, message: "Should be <= 999999999.99"}
    validates :amount, format: { with: /\A\d{1,9}(\.\d{0,2})?\z/ , message: "Should be in format: xxxxxxxxx.xx"}

    validates_presence_of :period, message: "Can't be blank"
    validates :period, numericality: {message: "Should be a number"}
    validates :period, numericality: {greater_than_or_equal_to: 12, message: "Should be >= 12"}
    validates :period, numericality: {less_than_or_equal_to: 600, message: "Should be <= 600"}

	enum installment_type: { equal: 0, decreasing: 1 }
    validates_presence_of :installment_type, message: "Can't be blank"
    
    def self.init
        loan = self.new
        loan.margins.build
        loan
    end

    def self.build(loan_params)
       loan = self.new(loan_params)
       loan.margins.build(loan_params.require(:margins_attributes).values)
       loan
    end

    def currency_amount
        if !amount.nil?
            if !currency.nil?
                @currency_amount = Money.from_amount(amount, currency)
            else 
                @currency_amount = Money.from_amount(amount)
            end
        end
    end

    def currency_amount=(currency_amount)
        self[:amount] = currency_amount.amount
        self[:currency]   = currency_amount.currency_as_string

        @currency_amount = currency_amount
    end

end
