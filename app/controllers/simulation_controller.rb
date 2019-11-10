class SimulationController < ApplicationController

    def self.CURRENCIES
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
        @simulation = Simulation.init
        @currencies = SimulationController.CURRENCIES
    end

    def edit
        @simulation = Simulation.find(params[:id])
        if !@simulation.loan.margins.any?
            @simulation.loan.margins.build
        end
        @currencies = SimulationController.CURRENCIES
    end

    def create
        @simulation = Simulation.build(simulation_params)
        @simulation_valid = @simulation.valid?

        if !@simulation_valid 
            logger.debug "simulation.errors = #{@simulation.errors.full_messages.join("; ")}"

            render_new
        else
            if @simulation.save
                redirect_to :action => 'list'
            else
                render_new
            end
        end
    end

    def update
        @simulation = Simulation.find(params[:id])
        if !@simulation.loan.margins.any?
            @simulation.loan.margins.build(simulation_params.require(:loan_attributes).require(:margins_attributes).values)
        end
        @simulation_valid = @simulation.valid?

        if !@simulation_valid 
            logger.debug "simulation.errors = #{@simulation.errors.full_messages.join("; ")}"

            render_edit
        else
            if @simulation.update_attributes(simulation_params) 
                redirect_to :action => 'show', :id => @simulation
            else
                render_edit
            end
        end
    end

    def delete
        Simulation.find(params[:id]).destroy
        redirect_to :action => 'list'
    end

    private 

    def simulation_params
        params.require(:simulation).permit(
            :id,
            :name, 
            :loan_attributes => [
                :id, 
                :amount, 
                :currency, 
                :period,
                :installment_type,
                :margins_attributes => [:id, :interest]
            ]
        )
    end

    def render_new
        @currencies = SimulationController.CURRENCIES
        render :action => 'new'
    end

    def render_edit
        @currencies = SimulationController.CURRENCIES
        render :action => 'edit'
    end


end
