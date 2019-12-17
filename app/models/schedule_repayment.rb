class ScheduleRepayment
    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Naming
    
    attr_accessor :number
    attr_accessor :date
    attr_accessor :total_amount
    attr_accessor :interest_amount
    attr_accessor :capital_amount
    
    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end
    
    def persisted?
      false
    end

    def to_s
      "ScheduleRepayment( " +
        "number = #{number}, " +
        "date = #{date.nil? ? "nil" : (date.strftime "%F")}, "+
        "interest_amount = #{interest_amount.nil? ? "nil" : interest_amount.amount}, "+
        "capital_amount = #{capital_amount.nil? ? "nil" : capital_amount.amount}, "+
        "total_amount = #{total_amount.nil? ? "nil" : total_amount.amount} " +
        ")"
    end

end

