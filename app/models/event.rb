class Event < ActiveRecord::Base
	attr_accessible :allDay,:color, :desc, :from, :name, :position, :privacy, :to, :user_id,
  :fromtime, :fromdate, :totime, :todate,:period, :frequency, :times, :event_set_id
  attr_accessor :period, :frequency, :commit, :fromtime, :fromdate, :totime, :todate, :times

  validates :name, presence:true, length: {minimum: 4, maximum: 100}
  validates :user_id, presence: true
  validates :from, presence: true
  validates :to, presence: true
  validate :valid_to
  VALID_COLOR_REGEX = /^#(([a-fA-F0-9]){3}){1,2}$/
  validates :color, format: { with: VALID_COLOR_REGEX }
  belongs_to :user
  belongs_to :event_set

  after_initialize :get_datetimes
	before_validation :set_datetimes # convert accessors back to db format
  default_scope order: 'events.created_at DESC'

  REPEATS = [
    "Does not repeat",
    "Daily"          ,
    "Weekly"         ,
    "Monthly"        ,
    "Yearly"         
  ]

  def set_datetimes
    self.fromtime||="00"
    self.totime||="01"
    self.from = "#{self.fromdate} #{self.fromtime}:00" # convert the two fields back to db
    self.to = "#{self.todate} #{self.totime}:00"
  end  

  def get_datetimes
   	self.from ||= Time.now  # if the published_at time is not set, set it to now
   	self.to ||= 1.hour.from_now # if the published_at time is not set, set it to now

   	self.fromdate ||= self.from.to_date.strftime('%d-%m-%Y') # extract the date is yyyy-mm-dd format
   	self.fromtime ||= "#{'%02d' % self.from.hour}:#{'%02d' % self.from.min}" unless self.allDay # extract the time

   	self.todate ||= self.to.to_date.strftime('%d-%m-%Y') # extract the date is yyyy-mm-dd format
   	self.totime ||= "#{'%02d' % self.to.hour}:#{'%02d' % self.to.min}" unless self.allDay # extract the time
  end

  def update_events(events, event)
    events.each do |e|
      begin 
        st, et = e.to, e.from
        e.attributes = event
        if event_set.period.downcase == 'monthly' or event_set.period.downcase == 'yearly'
          nst = DateTime.parse("#{e.from.hour}:#{e.from.min}:#{e.from.sec}, #{e.from.day}-#{st.month}-#{st.year}")  
          net = DateTime.parse("#{e.to.hour}:#{e.to.min}:#{e.to.sec}, #{e.to.day}-#{et.month}-#{et.year}")
        else
          nst = DateTime.parse("#{e.from.hour}:#{e.from.min}:#{e.from.sec}, #{st.day}-#{st.month}-#{st.year}")  
          net = DateTime.parse("#{e.to.hour}:#{e.to.min}:#{e.to.sec}, #{et.day}-#{et.month}-#{et.year}")
        end
      rescue
        nst = net = nil
      end
      if nst and net
        e.from, e.to = nst, net
        e.save
      end
    end
    
    event_set.attributes = event
    event_set.save
  end


  def valid_to
    errors.add(:to,"time must be greater than the from time") unless to > from
  end

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
#  allDay     :boolean
#

