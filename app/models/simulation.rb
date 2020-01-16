class Simulation < ApplicationRecord

    validates :name, length: { minimum: 1,  message: "Can't be blank" }
    validates :name, length: { maximum: 256,  message: "Can be maximum of 256 characters" }

    has_one :loan, dependent: :destroy
    accepts_nested_attributes_for :loan

    def validate
        loan.validate_margins
    end

    def self.init
        simulation = self.new
        simulation.loan = Loan.init
        simulation
    end

    def self.build(simulation_params)
        simulation = self.new(simulation_params)
        simulation.loan = Loan.build(simulation_params.require(:loan_attributes)) 
        simulation
    end

    def update(simulation_params)
        assign_attributes(simulation_params)
        loan.update(simulation_params.require(:loan_attributes)) 
    end

    def prepare
        if !loan.nil?
            loan.prepare
        end
    end

end
