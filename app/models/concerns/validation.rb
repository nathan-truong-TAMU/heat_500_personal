# Handles validation for all input data
require 'open-uri'
require 'net/http'

module Validation
    extend ActiveSupport::Concern

    def is_input_empty(input)
        input.nil? || (input.is_a?(String) && input.strip.empty?) 
    end

    included do
        # Checks if the inputted name is valid
        def is_valid_name
            # Checks for an empty name
            if is_input_empty(name)
                errors.add(:name, "can't be blank!")
            end
        end

        # Checks if the inputted title is valid
        def is_valid_title
            # Checks for an empty name
            if is_input_empty(title)
                errors.add(:title, "can't be blank!")
            end
        end

        # Checks if the inputted points is valid
        def is_valid_points
            # Checks for negative points
            if points.present? && points < 0
                errors.add(:points, "can't be negative!")

            # Checks for empty points
            elsif is_input_empty(points)
                # This handles the case where points is an empty string or nil.
                errors.add(:points, "can't be blank!")
            end
        end

        #Checks if the email is valid
        def is_valid_email
            if is_input_empty(email)
                errors.add(:email, "can't be blank!")
            elsif !email.match(/[a-zA-Z0-9.!#$%&*+\=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+/)
                #email format validation to make sure it actually ends properly with .com,.edu, etc
                errors.add(:email, "needs to be a valid email, i.e. example@example.com")
            end
        end

        # Checks if the inputted link is valid
        def is_valid_link
            # Checks for empty link
            if is_input_empty(link)
                errors.add(:link, "can't be blank!")

            else
                # Checks if the link is reachable
                begin
                    open(link) do |response|
                    end

                # Handles if link isn't reachable
                rescue StandardError => e
                    errors.add(:link, "must be reachable! (Error: #{e.message})")
                end
            end
        end

        # Checks if the inputted link is valid
        def is_valid_url
            # Checks for empty link
            if is_input_empty(url)
                errors.add(:url, "can't be blank!")

            else
                # Checks if the link is reachable
                begin
                    open(url) do |response|
                    end

                # Handles if link isn't reachable
                rescue StandardError => e
                    errors.add(:url, "must be reachable! (Error: #{e.message})")
                end
            end
        end

        # Checks if the inputted Start and End dates are valid
        def is_valid_dates
            if start_date.present? && end_date.present?
                if start_date > end_date
                    errors.add(:start_date, "can't be after the End date!")
                end
            end
        end
    end
end