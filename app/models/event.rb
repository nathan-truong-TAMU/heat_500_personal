class Event < ApplicationRecord
    has_many :events_members
    has_many :members, through: :events_members
    
    # Validates inputted variables
    include Validation
    validate :is_valid_name
    validate :is_valid_points
    validate :is_valid_dates
end
