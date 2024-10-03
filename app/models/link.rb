class Link < ApplicationRecord
    has_one :events, dependent: :destroy
end
