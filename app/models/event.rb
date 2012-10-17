class Event < ActiveRecord::Base
	attr_accessible :allDay,:color, :desc, :from, :name, :position, :privacy, :to, :user_id, :work,:fromtime, :fromdate, :totime, :todate

	validates :name, presence:true, length: {minimum: 4, maximum: 100}
	validates :user_id, presence: true
	validates :from, presence: true
	validates :to, presence: true
	validates :work, presence:true  
	VALID_COLOR_REGEX = /^#(([a-fA-F0-9]){3}){1,2}$/
  	validates :color, format: { with: VALID_COLOR_REGEX }
	belongs_to :user
	belongs_to :event_set

	attr_accessor :fromtime, :fromdate, :totime, :todate

	after_initialize :get_datetimes
  	before_validation :set_datetimes, :set_privacy # convert accessors back to db format

  	def set_datetimes
    	self.from = "#{self.fromdate} #{self.fromtime}:00" # convert the two fields back to db
    	self.to = "#{self.todate} #{self.totime}:00"
  	end  

  	def get_datetimes
    	self.from ||= Time.now  # if the published_at time is not set, set it to now
    	self.to ||= Time.now  # if the published_at time is not set, set it to now

    	self.fromdate ||= self.from.to_date.strftime('%d/%m/%Y') # extract the date is yyyy-mm-dd format
    	self.fromtime ||= "#{'%02d' % self.from.hour}:#{'%02d' % self.from.min}" # extract the time

    	self.todate ||= self.to.to_date.strftime('%d/%m/%Y') # extract the date is yyyy-mm-dd format
    	self.totime ||= "#{'%02d' % self.to.hour}:#{'%02d' % self.to.min}" # extract the time
  	end

  	def set_privacy
  		self.privacy=0 if self.work
  	end

	default_scope order: 'events.created_at DESC'


end
# == Schema Information
#
# Table name: events
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  from       :datetime
#  to         :datetime
#  position   :string(255)
#  desc       :string(255)
#  color      :string(255)     default("0")
#  privacy    :integer         default(0)
#  work       :boolean
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

