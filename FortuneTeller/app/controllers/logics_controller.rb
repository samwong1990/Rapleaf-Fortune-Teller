class LogicsController < ApplicationController
    def index
        @query = query = Query.find(params[:query_id])
        begin
            path_to_apikey = "APIKEY"
            apikey = IO.read(path_to_apikey).strip
            api = RapleafApi::Api.new(apikey) # Set API key here
            # hash = api.query_by_email(query.email)
            hash = api.query_by_email('ab@cd.com')
            @facts = hash.inspect
            # @bulk = bulk = api.bulk_query(query.dataset.each_line, show_available = true)
            set = Array.new
            query.dataset.each_line{|x| set << {'email' => x.strip}}
            @set = set
            @bulk = bulk = api.bulk_query(set, show_available = true)
        rescue Exception => e
            puts e.message
            @errormessage = Dir.getwd + e.message
        end       
        stock = "You have a great need for other people to like and admire you. You have a tendency to be critical of yourself. You have a great deal of unused capacity which you have not turned to your advantage. While you have some personality weaknesses, you are generally able to compensate for them. Disciplined and self-controlled outside, you tend to be worrisome and insecure inside. At times you have serious doubts as to whether you have made the right decision or done the right thing. You prefer a certain amount of change and variety and become dissatisfied when hemmed in by restrictions and limitations. You pride yourself as an independent thinker and do not accept others' statements without satisfactory proof. You have found it unwise to be too frank in revealing yourself to others. At times you are extroverted, affable, sociable, while at other times you are introverted, wary, reserved. Some of your aspirations tend to be pretty unrealistic. Security is one of your major goals in life."
        stock = stock.split(".")
        stock.each_with_index {|value, index| stock[index] = value.strip }
        line = Array.new
        unless hash.nil? || hash.length <= 0
            hash.each do|field, value|
                case field
                when "age"
                    if  value < 12
                        age_group = "a kid"
                    elseif  value < 18
                        age_group = "a teen"
                    elseif  value < 25
                        if hash.has_key("gender")
                            if hash["gender"].casecmp("female") == 0
                                age_group = "a young lady"
                            else
                                age_group = "a young man"
                            end
                        else
                            age_group = "still young"
                        end
                    else
                        age_group = "a grown up"
                    end
                    line << "People say you are " + age_group + "."
                when "gender"
                    if  value.casecmp("female") == 0
                        line << "You are a nice lady"
                    else
                        line << "You are a man"
                    end
                end            
            end
        end
        lines = line | stock
        lines = lines.shuffle
        @lines = lines.join(". ") + "."
        @debug = lines.inspect
        
    end
    
    def upload
    end

    def about
        @line = 'blahblahblah'
        # @queries.each do |query|
        #     line += query.inspect
        # end
    end
       
    def result
        
        begin
            path_to_apikey = "APIKEY"
            apikey = IO.read(path_to_apikey).strip
            api = RapleafApi::Api.new(apikey) # Set API key here
            hash = api.query_by_email("emmaedwards@google.com")
            @facts = hash.inspect
        rescue Exception => e
            puts e.message
            @ex = Dir.getwd + e.message
        end
            stock = "You have a great need for other people to like and admire you. You have a tendency to be critical of yourself. You have a great deal of unused capacity which you have not turned to your advantage. While you have some personality weaknesses, you are generally able to compensate for them. Disciplined and self-controlled outside, you tend to be worrisome and insecure inside. At times you have serious doubts as to whether you have made the right decision or done the right thing. You prefer a certain amount of change and variety and become dissatisfied when hemmed in by restrictions and limitations. You pride yourself as an independent thinker and do not accept others' statements without satisfactory proof. You have found it unwise to be too frank in revealing yourself to others. At times you are extroverted, affable, sociable, while at other times you are introverted, wary, reserved. Some of your aspirations tend to be pretty unrealistic. Security is one of your major goals in life."
            stock = stock.split(".")
            stock.each_with_index {|value, index| stock[index] = value.strip }
            line = Array.new
            unless hash.length < 0
                hash.each do|field, value|
                    case field
                    when "age"
                        if  value < 12
                            age_group = "a kid"
                        elseif  value < 18
                            age_group = "a teen"
                        elseif  value < 25
                            if hash.has_key("gender")
                                if hash["gender"].casecmp("female") == 0
                                    age_group = "a young lady"
                                else
                                    age_group = "a young man"
                                end
                            else
                                age_group = "still young"
                            end
                        else
                            age_group = "a grown up"
                        end
                        line << "People say you are " + age_group + "."
                    when "gender"
                        if  value.casecmp("female") == 0
                            line << "You are a nice lady"
                        else
                            line << "You are a man"
                        end
                    end            
                end
            end
            lines = line | stock
            lines = lines.shuffle
            @lines = lines.join(". ") + "."
            @debug = lines.inspect

    end

end
