class InterestPeriod < ApplicationRecord

    belongs_to :loan

    validates_presence_of :interest, message: "Can't be blank"
    validates :interest, numericality: {message: "Should be a number"}
    validates :interest, numericality: {greater_than_or_equal_to: 0.00, message: "Should be >= 0.00"}
    validates :interest, numericality: {less_than_or_equal_to: 99.999999, message: "Should be <= 99.999999"}
    validates :interest, format: { with: /\A\d{0,2}(\.\d{0,6})?\z/ , message: "Should be in format: xx.xxxxxx"}

    validates_presence_of :date_from, message: "Can't be blank"
    validates :date_from, format: { with: /\A\d{4}-\d{2}-\d{2}\z/ , message: "Should be in format: yyyy-mm-dd"}

    validates :date_to, format: { with: /\A\d{4}-\d{2}-\d{2}\z/ , message: "Should be in format: yyyy-mm-dd"},
        if: -> { self.date_to_present == '1' }

    attr_accessor :date_to_present

    def prepare
        @date_to_present = date_to.present?
    end

    def update(margin_params)
        if margin_params[:date_to_present] == '0'
            margin_params[:date_to] = nil
        end
        assign_attributes(margin_params)
    end

    def to_s
      "InterestPeriod( " +
        "interest = #{interest}, " +
        "date_from = #{date_from.nil? ? "nil" : (date_from.strftime "%F")}, " +
        "date_to = #{date_to.nil? ? "nil" : (date_to.strftime "%F")}, " +
        "date_to_present = #{date_to_present} " +
        ")"
    end

end