class Member < ApplicationRecord
    has_many :events_members
    has_many :events, through: :events_members
    has_many :announcements, dependent: :nullify

    # Validates inputted variables
    include Validation
    validate :is_valid_name
    validate :is_valid_points
    validate :is_valid_email
end
