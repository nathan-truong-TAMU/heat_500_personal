class Link < ApplicationRecord
    include Validation
    validate :is_valid_title
end
