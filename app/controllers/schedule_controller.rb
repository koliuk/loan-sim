class ScheduleController < ApplicationController
    include Pagy::Backend

    layout 'application'

    # look at https://github.com/RubyMoney/money#deprecation
    Money.locale_backend = nil

    def self.PAGE_SIZES
        [6, 12, 24, 36 ,48]
    end

    def self.PAGE_SIZE_DEFAULT
        12
    end

    def repayments
        @actual_page_size = params[:items].present? ? params[:items].to_i : ScheduleController.PAGE_SIZE_DEFAULT
        @simulation = Simulation.find(params[:id])
        @pagy, @repayments = pagy_array(prepare_schedule(@simulation.loan), items: @actual_page_size)
    end

    private

    def prepare_schedule(loan)
        repayments = Array.new
        for i in 1..loan.period
            repayments << prepare_schedule_repayment(i, loan)
            # logger.debug "#{repayments[i-1].to_s}"
        end
        repayments
    end

    def prepare_schedule_repayment(number, loan)
        repayment = ScheduleRepayment.new
        repayment.number = number
        repayment.date = Date.current >> (number - 1)
        # TODO: use BigDecimal
        if loan.installment_type == "equal"
            amount = ExcelPmtHelper.pmt(loan.margins[0].interest/1200, loan.period, (-1) * loan.amount)
            repayment.total_amount = Money.from_amount(amount, loan.currency)

            amount = ExcelPmtHelper.ipmt(loan.margins[0].interest/1200, number, loan.period, (-1) * loan.amount)
            repayment.interest_amount = Money.from_amount(amount, loan.currency)

            repayment.capital_amount = repayment.total_amount - repayment.interest_amount
        else
            amount = (loan.amount / loan.period) * (loan.period - number + 1) * (loan.margins[0].interest/1200)
            repayment.interest_amount = Money.from_amount(amount, loan.currency)

            amount = loan.amount / loan.period
            repayment.capital_amount = Money.from_amount(amount, loan.currency)

            repayment.total_amount = repayment.interest_amount + repayment.capital_amount
        end

        repayment
    end

end
