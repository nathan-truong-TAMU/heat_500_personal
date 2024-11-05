class Link < ApplicationRecord
  include Validation
  validate :is_valid_title
  validate :is_valid_link
end
