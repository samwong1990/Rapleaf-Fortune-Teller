class FortuneTeller < ActiveRecord::Base
    validates :name, :email, presence: true
    validates :email, :email => true
    def to_param
        "#{session}"
    end
end
