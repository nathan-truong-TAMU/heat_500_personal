class Link < ApplicationRecord
    has_one :event, dependant: :destroy
end
