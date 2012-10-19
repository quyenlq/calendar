class EventSetsController < ApplicationController
	before_filter :signed_in_user
	
	def new
		@event_set = EventSet.new
		respond_to do |format|
			format.js
		end
	end

	def update
		@event_set = EventSet.new(params[:event_set])
		if @event_set.save
		else
		end
	end

 private
  	def correct_user
      @event = current_user.events.find_by_id(params[:id])
      redirect_to root_url if @event.nil?
  	end

    def signed_in_user
      redirect_to root_url unless signed_in?
    end
end
