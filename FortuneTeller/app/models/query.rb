class Query < ActiveRecord::Base
    validates :name, :email, :dataset, presence: true
    

end
