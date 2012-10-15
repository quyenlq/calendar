class EventsController < ApplicationController
	before_filter :correct_user, only: [:destroy, :edit, :update,:move, :resize]
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

	def get_events
    	@events = current_user.events.all
    	public_events = Event.find(:all, :conditions => ["privacy == 0 and user_id != #{current_user.id}"] )
    	public_events.each do |pe|
    		@events << pe
    	end
    	events = [] 
    	@events.each do |event|
      		events << {:id => event.id, :title => event.name, :description => event.desc || "Some cool description here...", :start => "#{event.from.iso8601}", :end => "#{event.to.iso8601}"}
    	end
    	render :text => events.to_json
  	end

  	def move
    @event = Event.find_by_id params[:id]
    if @event
      new_from = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.from))
      new_to = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.to))
      # @event.all_day = params[:all_day]      
      @event.update_attribute("from", new_from)
      @event.update_attribute("to", new_to)
    end
    respond_to do |format|
      format.js
    end
  end
  
  
  def resize
    @event = Event.find_by_id params[:id]    
    if @event
      new_to = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.to))
      @event.update_attribute("to",new_to)
    end

    respond_to do |format|
      format.js
    end    
  end
  
  def edit
    @event = Event.find_by_id(params[:id])
  end
  
  def update
    @event = Event.find_by_id(params[:event][:id])
    if params[:event][:commit_button] == "Update All Occurrence"
      @events = @event.event_series.events #.find(:all, :conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
      @event.update_events(@events, params[:event])
    elsif params[:event][:commit_button] == "Update All Following Occurrence"
      @events = @event.event_series.events.find(:all, :conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
      @event.update_events(@events, params[:event])
    else
      @event.attributes = params[:event]
      @event.save
    end

    respond_to do |format|
      format.js       
    end
    
  end  
  
  def destroy
    @event = Event.find_by_id(params[:id])
    if params[:delete_all] == 'true'
      @event.event_series.destroy
    elsif params[:delete_all] == 'future'
      @events = @event.event_series.events.find(:all, :conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
      @event.event_series.events.delete(@events)
    else
      @event.destroy
    end
    
    respond_to do |format|
      format.js       
    end
    
  end

  private
  	def correct_user
      @event = current_user.events.find_by_id(params[:id])
      redirect_to root_url if @event.nil?
  	end
end
