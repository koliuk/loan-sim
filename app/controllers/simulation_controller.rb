class SimulationController < ApplicationController

    layout 'application'

    # look at https://github.com/RubyMoney/money#deprecation
    Money.locale_backend = nil

    def self.CURRENCIES
        ['PLN']
    end

    def list
        @simulations = Simulation.all
    end

    def show
        @simulation = Simulation.find(params[:id])
    end

    def new
        @simulation = Simulation.init
    end

    def edit
        @simulation = Simulation.find(params[:id])
        @simulation.prepare
    end

    def create
        simulation = Simulation.build(simulation_params)
        simulation_valid = simulation.valid? && simulation.validate

        if !simulation_valid
            logger.debug "simulation.errors = #{simulation.errors.full_messages.join("; ")}"
            @simulation = simulation
            render :action => 'new'
        else
            if simulation.save
                redirect_to :action => 'list'
            else
                @simulation = simulation
                render :action => 'new'
            end
        end
    end

    def update
        simulation = Simulation.find(params[:id])
        simulation.update(simulation_params)

        simulation_valid = simulation.valid? && simulation.validate

        if !simulation_valid
            logger.debug "simulation.errors = #{simulation.errors.full_messages.join("; ")}"
            @simulation = simulation
            render :action => 'edit'
        else
            if simulation.save
                redirect_to :action => 'show', :id => simulation
            else
                @simulation = simulation
                render :action => 'edit'
            end
        end
    end

    def delete
        Simulation.find(params[:id]).destroy
        redirect_to :action => 'list'
    end

    def delete_margin
        if params[:margin_id].present?
            @interest = InterestPeriod.find(params[:margin_id])
            logger.debug "Destroy #{params[:margin_id]}"
            @interest.destroy
            @deleted = "true"
        end
        @margin_id = params[:margin_id]    
        @margin_idx = params[:margin_idx]  
        respond_to do |delete_margin|
            delete_margin.js
        end
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
                :margins_attributes => [
                    :id,
                    :interest,
                    :date_from,
                    :date_to,
                    :date_to_present
                ]
            ]
        )
    end

end
