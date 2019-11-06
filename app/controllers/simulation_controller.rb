class SimulationController < ApplicationController

	def self.currencies
		['PLN']
	end

	layout 'application'

	def list
		@simulations = Simulation.all
	end

	def show
		@simulation = Simulation.find(params[:id])
	end

	def new
		@simulation = Simulation.new
        @loan = @simulation.build_loan
        @currencies = SimulationController.currencies
	end

	def edit
	   @simulation = Simulation.find(params[:id])
	   @loan = @simulation.loan
       @currencies = SimulationController.currencies
	end

	def create
		@simulation = Simulation.new(simulation_params)
		@loan = @simulation.build_loan(loan_params) 

		@simulation_valid = @simulation.valid?
		@loan_valid = @loan.valid?

		if !@simulation_valid || !@loan_valid
			logger.debug "simulation.errors = #{@simulation.errors.full_messages.join("; ")}"
			logger.debug "loan.errors = #{@loan.errors.full_messages.join("; ")}"

			@currencies = SimulationController.currencies
			render :action => 'new'
		else
			if @simulation.save
				redirect_to :action => 'list'
			else
				@currencies = SimulationController.currencies
				render :action => 'new'
			end
		end
	end

	def simulation_params
		params.require(:simulation).permit(:name)
	end

	def loan_params
		params.require(:loan).permit(:amount, :currency, :period)
	end

	def update
	   	@simulation = Simulation.find(params[:id])
	   	@loan = @simulation.loan

		@simulation_valid = @simulation.valid?
		@loan_valid = @loan.valid?

		if !@simulation_valid || !@loan_valid
			logger.debug "simulation.errors = #{@simulation.errors.full_messages.join("; ")}"
			logger.debug "loan.errors = #{@loan.errors.full_messages.join("; ")}"

			@currencies = SimulationController.currencies
			render :action => 'edit'
		else
			if @simulation.update_attributes(simulation_params) && @loan.update_attributes(loan_params)
				redirect_to :action => 'show', :id => @simulation
			else
				@currencies = SimulationController.currencies
				render :action => 'edit'
			end
		end
	end


	def delete
		Simulation.find(params[:id]).destroy
		redirect_to :action => 'list'
	end

end
