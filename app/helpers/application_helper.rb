module ApplicationHelper
    def valid_url?(url)
        url =~ /\A(http|https):\/\/[^\s\/$.?#].[^\s]*\z/
    end
end
