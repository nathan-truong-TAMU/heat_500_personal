class Member < ApplicationRecord
    # new code
    has_many :events_members
    has_many :events, through: :events_members
end
