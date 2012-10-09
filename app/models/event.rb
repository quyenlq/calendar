class Event < ActiveRecord::Base
  attr_accessible :color, :desc, :from, :name, :position, :privacy, :to, :user_id, :work
  validate :name, presence:true, length: {minimum: 4, maximum: 100}
  validate :user_id, presence: true
  validate :from, presence: true
  validate :to, presence: true
  validate :work, presence:true  
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
#  color      :integer
#  privacy    :integer
#  work       :boolean
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

