class Event < ApplicationRecord
  has_many :events_members
  has_many :members, through: :events_members
  belongs_to :link
end
