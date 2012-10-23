class EventSet < ActiveRecord::Base
  attr_accessible :allDay, :frequency, :from, :period, :to, :weekdays,:name, :desc, :commit, :color,
                  :fromdate, :todate, :fromtime, :totime, :position, :work, :times, :privacy
  attr_accessor :name, :desc, :commit, :color, :fromdate, :todate, :position, :work, :fromtime, :totime, :times, :privacy
  
  validates_presence_of :frequency, :period, :from, :to
  validates_presence_of :name, :color
  validates :times, :numericality => {:greater_than => 0, :only_integer => true}
  
  has_many :events, :dependent => :destroy
  belongs_to :user

  after_save :create_events
  after_initialize :get_datetimes
  before_validation :set_datetimes

  END_TIME = Date.parse("1 Jan, 2020").to_time

  default_scope order: 'event_sets.created_at DESC'

  def create_events
    t = times.to_i
    if t
      st = from
      et = to
      p = r_period(period)
      nst, net = st, et
      t.times do 
        e=self.user.events.create(:name => name, :desc => desc, :position => position , :allDay => allDay, :from => nst, :to => net,:color => color, :privacy => :privacy, :event_set_id => self.id)
        nst = st = frequency.send(p).from_now(st)
        net = et = frequency.send(p).from_now(et)
      
        if period.downcase == 'monthly' or period.downcase == 'yearly'
          begin 
            nst = DateTime.parse("#{from.hour}:#{from.min}:#{from.sec}, #{from.day}-#{st.month}-#{st.year}")  
            net = DateTime.parse("#{to.hour}:#{to.min}:#{to.sec}, #{to.day}-#{et.month}-#{et.year}")
          rescue
            nst = net = nil
          end
        end
      end
    else create_events_until_end
    end
  end

  def create_events_until_end
    st = from
    et = to
    p = r_period(period)
    nst, net = st, et
    while frequency.send(p).from_now(st) <= END_TIME
      self.user.events.create(:name => name, :desc => desc, :allDay => allDay, :from => nst, :to => net,:color => color, :privacy => privacy)
      nst = st = frequency.send(p).from_now(st)
      net = et = frequency.send(p).from_now(et)
      
      if period.downcase == 'monthly' or period.downcase == 'yearly'
        begin 
          nst = DateTime.parse("#{from.hour}:#{from.min}:#{from.sec}, #{from.day}-#{st.month}-#{st.year}")  
          net = DateTime.parse("#{to.hour}:#{to.min}:#{to.sec}, #{to.day}-#{et.month}-#{et.year}")
        rescue
          nst = net = nil
        end
      end
    end
  end

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
  
  def r_period(period)
    case period
      when 'Daily'
      p = 'days'
      when "Weekly"
      p = 'weeks'
      when "Monthly"
      p = 'months'
      when "Yearly"
      p = 'years'
    end
    return p
  end
end
# == Schema Information
#
# Table name: event_sets
#
#  id         :integer         not null, primary key
#  frequency  :integer
#  period     :string(255)
#  from       :datetime
#  to         :datetime
#  allDay     :boolean
#  weekdays   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

