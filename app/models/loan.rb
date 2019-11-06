require 'money'

class Loan < ApplicationRecord
	has_one :simulation

	validates_presence_of :currencyAmount

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
	
	def currencyAmount
		if !amount.nil?
			if !currency.nil?
				@currencyAmount = Money.from_amount(amount, currency)
			else 
				@currencyAmount = Money.from_amount(amount)
			end
		end
	end

	def currencyAmount=(currencyAmount)
		self[:amount] = currencyAmount.amount
		self[:currency]   = currencyAmount.currency_as_string

		@currencyAmount = currencyAmount
	end

end
