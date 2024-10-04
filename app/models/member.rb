class Member < ApplicationRecord
    has_many :events_members
    has_many :events, through: :events_members
    has_many :announcements, dependent: :nullify
end
