require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
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

