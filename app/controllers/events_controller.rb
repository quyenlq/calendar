class EventsController < ApplicationController
	def show
	end

	def index
	end

	def new
		@event = Event.new
	end

	def create
		@event = current_user.events.build(params[:event])
		if(@event.save)
			flash[:success] = "Created new event"
			redirect_to root_url
		else
			render 'new'
		end
	end
end
