class Member < ApplicationRecord
    has_many :events_members
    has_many :events, through: :events_members
    has_many :announcements, dependent: :nullify

    # Validates inputted variables
    validate :is_valid_name
    validate :is_valid_points


    # Custom validation functions
    private
        # Checks if the inputted name is valid
        def is_valid_name
            # Checks for an empty name
            if name.is_a?(String) && name.strip.empty?
                errors.add(:name, "can't be blank!")
            end
        end

        # Checks if the inputted points is valid
        def is_valid_points
            # Checks for negative points
            if points.present? && points < 0
                errors.add(:points, "can't be negative!")

            # Checks for empty points
            elsif points.nil? || (points.is_a?(String) && points.strip.empty?)
                # This handles the case where points is an empty string or nil.
                errors.add(:points, "can't be blank!")
            end
        end
end
