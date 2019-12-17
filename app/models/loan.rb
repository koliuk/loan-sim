require 'money'

class Loan < ApplicationRecord

    has_one :simulation
    
    has_many :margins, -> { order(id: :asc) }, inverse_of: :loan, class_name: "InterestPeriod", dependent: :destroy
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
        loan.margins.push(InterestPeriod.new)
        loan
    end

    def self.build(loan_params)
        loan = self.new(loan_params)
        loan.margins.build(loan_params.require(:margins_attributes).values)
        loan
    end

    def self.sort_margins(margins)
        margins.sort_by {|m| m.date_from}
    end

    def update(loan_params)
        assign_attributes(loan_params)
        update_margins(loan_params)
    end

    def update_margins(loan_params)
        margins_map = Hash.new(0)
        margins.each do |margin|
            margins_map.store(margin.id.to_s, margin)
        end
        loan_params.require(:margins_attributes).values.each do |margin_params|
            if margins_map.key?(margin_params[:id])
                margins_map[margin_params[:id]].update(margin_params)
            else
                margins.push(InterestPeriod.new(margin_params))
            end
        end
    end

    def prepare
        if margins.empty?
            margins.push(InterestPeriod.new)
        end
        margins.each do |margin|
            margin.prepare
        end
    end

    def validate_margins
        sorted_margins = Loan.sort_margins(margins)
        sorted_margins.each_with_index do |margin, i|
            if(!validate_margin(margin, sorted_margins, i+1))
                return false
            end
        end
        true
    end

     def validate_margin(margin, margins, i)
        if i < margins.length
            if margin.date_to.nil?
                margin.errors.add(:date_to, "Coincides with the succeeding date: #{margins[i].date_from}.")
                margins[i].errors.add(:date_from, "Coincides with the preceding indefinitely date.")
                return false
            elsif (margin.date_to - margins[i].date_from).to_i >= 0
                margin.errors.add(:date_to, "Coincides with the succeeding date: #{margins[i].date_from}.")
                margins[i].errors.add(:date_from, "Coincides with the preceding date: #{margin.date_to}.")
                return false
            elsif (margin.date_to - margins[i].date_from).to_i < -1
                margin.errors.add(:date_to, "Discontinuity with the succeeding date: #{margins[i].date_from}.")
                margins[i].errors.add(:date_from, "Discontinuity with the preceding date: #{margin.date_to}.")
                return false
            end
         end
         true
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

    def to_s
      "Loan( " +
        "currency = #{currency}, " +
        "amount = #{amount}, " +
        "period = #{period}, " +
        "installment_type = #{installment_type}, " +
        "margins = #{margins.map { |margin| margin.to_s }} " +
        ")"
    end

end
