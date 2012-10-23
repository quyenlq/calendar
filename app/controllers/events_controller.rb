class EventsController < ApplicationController
	before_filter :correct_user, only: [:destroy, :edit, :update,:move, :resize]
  before_filter :signed_in_user
	def index
	end

	def new
		@event = Event.new
	end

	def create
		if(params[:event][:period] == "Does not repeat")
      @event = current_user.events.build(params[:event])
      if @event.save
			 flash[:success] = "Created new event"
			 redirect_to root_url
		  else
			 render 'new'
		  end
    else 
      @event_set = current_user.event_sets.build(params[:event])
      if @event_set.save
       flash[:success] = "Created new event"
       redirect_to root_url
      else
       redirect_to new_event_path
      end
    end
	end

  def select_partner    
    @users = User.find(:all, :conditions =>"id != #{current_user.id}")
      if @users
        respond_to do |format|
          format.js
        end
      end
  end

  def get_pevents
    @users=User.find(params[:user_ids])
    pevents=[]
    @users.each_with_index do |user,index|
      results = user.events.all#find(:all, :conditions => ["privacy != 2"])
      results.each do |result|
        pcolor = get_color(index)
        pevents<<{:id => result.id, :title => result.name, :description => result.desc, :color => pcolor, :start => "#{result.from.iso8601}", :end => "#{result.to.iso8601}",:allDay => result.allDay}
        end
    end
    @pevents = pevents.to_json.html_safe
  end

	def get_events
  	@events = current_user.events.all
  	events = [] 
  	@events.each do |event|
        if(event.event_set)
    		  events << {:id => event.id, :title => event.name, :description => event.desc,:position => event.position, :color => event.color, :start => "#{event.from.iso8601}", :end => "#{event.to.iso8601}",:allDay => event.allDay, :recurring => true}
        else
          events << {:id => event.id, :title => event.name, :description => event.desc,:position => event.position, :color => event.color, :start => "#{event.from.iso8601}", :end => "#{event.to.iso8601}",:allDay => event.allDay}
        end
  	end
  	render :text => events.to_json
  	end

  def move
    @event = Event.find_by_id params[:id]
    if @event
      new_from = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.from))
      new_to = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.to))
      @event.update_attribute("allDay",params[:allDay])
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
    respond_to do |format|
      format.js
    end
  end
  
  def update
    @event = Event.find(params[:id])
    if params[:commit] == "Update All Occurrence"
      @events = @event.event_set.events
      @event.update_events(@events, params[:event])
    elsif params[:commit] == "Update All Following Occurrence"
      @events = @event.event_set.events.find(:all, :conditions => ["'from' > '#{@event.from.to_formatted_s(:db)}' "])
      @event.update_events(@events, params[:event])
    else
      @event.update_attributes(params[:event])
      @event.save
    end

    respond_to do |format|
      format.js       
    end
    
  end  
  
  def destroy
    @event = Event.find_by_id(params[:id])
    if params[:delete_all] == 'true'
      @event.event_set.destroy
    elsif params[:delete_all] == 'future'
      @events = @event.event_set.events.find(:all, :conditions => ["'from' > '#{@event.from.to_formatted_s(:db)}' "])
      @event.event_set.events.delete(@events)
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

    def signed_in_user
      redirect_to root_url unless signed_in?
    end

    def get_color(index)
      color=['#FF6600','#008000','#FF99CC','#800080','#3366FF',
              '#99CCFF','#33CCCC','#993300','#333399','#FF00FF']
      return color[index]
    end
end
