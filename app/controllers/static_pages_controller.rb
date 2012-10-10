class StaticPagesController < ApplicationController
	def home
		@events = current_user.events.all
  		@date = params[:month] ? Date.parse(params[:month]) : Date.today		
	end
end
