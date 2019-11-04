class Simulation < ApplicationRecord
	validates :name, length: { minimum: 1,  message: "Name can't be blank" }
	validates :name, length: { maximum: 256,  message: "Name can be maximum of 256 characters" }
	has_one :loan, dependent: :destroy
end
