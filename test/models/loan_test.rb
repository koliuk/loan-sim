require 'test_helper'

class LoanTest < ActiveSupport::TestCase

    test "validate margins expected OK" do
        loan = Loan.init
        loan.margins = valid_margins()
        result = loan.validate_margins
        assert result
    end

    test "validate margins expected coincides preceding indefinitely date" do
        loan = Loan.init
        loan.margins = invalid_margins_coincides_indefinitely_date()
        result = loan.validate_margins
        assert !result
        assert loan.margins[0].errors.full_messages.join("; ") == "Date to Coincides with the succeeding date: 2020-02-13."
        assert loan.margins[2].errors.full_messages.join("; ") == "Date from Coincides with the preceding indefinitely date."
    end

    test "validate margins expected coincides preceding specified date" do
        loan = Loan.init
        loan.margins = invalid_margins_coincides_specified_date()
        result = loan.validate_margins
        assert !result
        assert loan.margins[2].errors.full_messages.join("; ") == "Date to Coincides with the succeeding date: 2021-06-30."
        assert loan.margins[1].errors.full_messages.join("; ") == "Date from Coincides with the preceding date: 2021-06-30."
    end

    test "validate margins expected discontinuity preceding specified date" do
        loan = Loan.init
        loan.margins = invalid_margins_discontinuity()
        result = loan.validate_margins
        assert !result
        assert loan.margins[0].errors.full_messages.join("; ") == "Date to Discontinuity with the succeeding date: 2020-02-14."
        assert loan.margins[2].errors.full_messages.join("; ") == "Date from Discontinuity with the preceding date: 2020-02-12."
    end

    def valid_margins()
        margins = Array.new
        margins.push(interest_period(1.34, Date.parse("2019-12-23"), Date.parse("2020-02-12")))
        margins.push(interest_period(1.43, Date.parse("2021-07-01"), nil))
        margins.push(interest_period(1.36, Date.parse("2020-02-13"), Date.parse("2021-06-30")))
        margins
    end

    def invalid_margins_coincides_indefinitely_date()
        margins = Array.new
        margins.push(interest_period(1.34, Date.parse("2019-12-23"), nil))
        margins.push(interest_period(1.43, Date.parse("2021-07-01"), nil))
        margins.push(interest_period(1.36, Date.parse("2020-02-13"), Date.parse("2021-06-30")))
        margins
    end

    def invalid_margins_coincides_specified_date()
        margins = Array.new
        margins.push(interest_period(1.34, Date.parse("2019-12-23"), Date.parse("2020-02-12")))
        margins.push(interest_period(1.43, Date.parse("2021-06-30"), nil))
        margins.push(interest_period(1.36, Date.parse("2020-02-13"), Date.parse("2021-06-30")))
        margins
    end

    def invalid_margins_discontinuity()
        margins = Array.new
        margins.push(interest_period(1.34, Date.parse("2019-12-23"), Date.parse("2020-02-12")))
        margins.push(interest_period(1.43, Date.parse("2021-07-01"), nil))
        margins.push(interest_period(1.36, Date.parse("2020-02-14"), Date.parse("2021-06-30")))
        margins
    end

   def interest_period(interest, date_from, date_to)
       ip = InterestPeriod.new
       ip.interest = interest
       ip.date_from = date_from
       ip.date_to = date_to
       ip.date_to_present = !date_to.nil?
       ip
   end
end
