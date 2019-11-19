Rails.application.routes.draw do
  	get 'simulation/list'
	get 'simulation/new'
	post 'simulation/create'
	get 'simulation/show'
	get 'simulation/edit'
	patch 'simulation/update'
	get 'simulation/delete'

    get 'schedule/repayments'

	root 'simulation#list'
	# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
