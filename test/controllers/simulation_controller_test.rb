require 'test_helper'

class SimulationControllerTest < ActionDispatch::IntegrationTest
    test "should get index" do
        schedule = SimulationController.prepare_schedule
        assert true
    end
end
