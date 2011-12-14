class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private
    def newsession
        Query.find(session[:query_id])
        rescue ActiveRecord::RecordNotFound
            query = Query.create
            session[:query_id] = query.id
            query
    end
  
end
