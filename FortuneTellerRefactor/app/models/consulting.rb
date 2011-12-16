class Consulting < ActiveRecord::Base
    validates :name, :email, :dataset, presence: true
    validates :email, :email => true
    def to_param
        "#{session}"
    end
end
