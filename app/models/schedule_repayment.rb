class ScheduleRepayment
    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Naming
    
    attr_accessor :number, :date, :total_amount, :interest_amount, :capital_amount
    
    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end
    
    def persisted?
      false
    end

    def to_str
      "ScheduleRepayment(
        number = #{number},
        date = #{date.strftime "%F"},
        interest_amount = #{interest_amount.amount},
        capital_amount = #{capital_amount.amount},
        total_amount = #{total_amount.amount}
        )"
    end

end

