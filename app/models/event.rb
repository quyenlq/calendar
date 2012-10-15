class Event < ActiveRecord::Base
	attr_accessible :color, :desc, :from, :name, :position, :privacy, :to, :user_id, :work,:fromtime, :fromdate, :totime, :todate

	validates :name, presence:true, length: {minimum: 4, maximum: 100}
	validates :user_id, presence: true
	validates :from, presence: true
	validates :to, presence: true
	validates :work, presence:true  
	validates :color, :numericality => { :only_integer => true, greater_than_or_equal_to: 0, less_than_or_equal_to: 9 }
	belongs_to :user

	attr_accessor :fromtime, :fromdate, :totime, :todate

  	before_validation :set_datetimes # convert accessors back to db format

  	def set_datetimes
    	self.from = "#{self.fromdate} #{self.fromtime}:00" # convert the two fields back to db
    	self.to = "#{self.todate} #{self.totime}:00"
  	end  

	default_scope order: 'events.created_at DESC'


end
# == Schema Information

# Table name: events
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  from       :datetime
#  to         :datetime
#  position   :string(255)
#  desc       :string(255)
#  color      :integer
#  privacy    :integer
#  work       :boolean
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

