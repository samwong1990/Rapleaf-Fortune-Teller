class FortuneTellersController < ApplicationController
    # GET /fortune_tellers
    # GET /fortune_tellers.json
    def index
        @fortune_tellers = FortuneTeller.all

        respond_to do |format|
            format.html # index.html.erb
            format.json { render json: @fortune_tellers }
        end
    end

    # GET /fortune_tellers/1
    # GET /fortune_tellers/1.json
    def show
        @fortune_teller = FortuneTeller.find_last_by_session(session[:session_id])
         if @fortune_teller.dataset.strip == ''
                redirect_to result_fortune_teller_path
        else
            respond_to do |format|
                format.html # show.html.erb
                format.json { render json: @fortune_teller }
            end
        end
    end

    # GET /fortune_tellers/new
    # GET /fortune_tellers/new.json
    def new
        @fortune_teller = FortuneTeller.new

        respond_to do |format|
            format.html # new.html.erb
            format.json { render json: @fortune_teller }
        end
    end

    # GET /fortune_tellers/1/edit
    def edit
        @fortune_teller = FortuneTeller.find_last_by_session(session[:session_id])
    end

    # POST /fortune_tellers
    # POST /fortune_tellers.json
    def create
        params[:fortune_teller]['session'] = session[:session_id]
        hashedEmails = Array.new
        params[:fortune_teller]['dataset'].each_line do |email|
            hashedEmails << Digest::SHA1.hexdigest(email.strip)
        end
        params[:fortune_teller]['hasheddataset'] = hashedEmails.join("\n")
        @fortune_teller = FortuneTeller.new(params[:fortune_teller])

        respond_to do |format|
            if @fortune_teller.save
                format.html { redirect_to @fortune_teller, notice: 'Fortune teller was successfully created.' }
                format.json { render json: @fortune_teller, status: :created, location: @fortune_teller }
            else
                format.html { render action: "new" }
                format.json { render json: @fortune_teller.errors, status: :unprocessable_entity }
            end
        end
    end

    # PUT /fortune_tellers/1
    # PUT /fortune_tellers/1.json
    def update

        params[:fortune_teller]['session'] = session[:session_id]
        hashedEmails = Array.new
        params[:fortune_teller]['dataset'].each_line do |email|
            hashedEmails << Digest::SHA1.hexdigest(email.strip)
        end
        params[:fortune_teller]['hasheddataset'] = hashedEmails.join("\n")
        @fortune_teller = FortuneTeller.find_by_session(session[:session_id])

        respond_to do |format|
            if @fortune_teller.update_attributes(params[:fortune_teller])
                format.html { redirect_to @fortune_teller, notice: 'Fortune teller was successfully updated.' }
                format.json { head :ok }
            else
                format.html { render action: "edit" }
                format.json { render json: @fortune_teller.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /fortune_tellers/1
    # DELETE /fortune_tellers/1.json
    def destroy
        @fortune_teller = FortuneTeller.find(params[:id])
        @fortune_teller.destroy

        respond_to do |format|
            format.html { redirect_to fortune_tellers_url }
            format.json { head :ok }
        end
    end

    def result
        @FortuneTeller = FortuneTeller.find_last_by_session(session[:session_id])
        @errormessages = Array.new
        path_to_apikey = "APIKEY"
        apikey = IO.read(path_to_apikey).strip
        
        # Get user details, retry 3 times to counteract random errors
        count_in_english = { 1 => 'first', 2 => 'second', 3 => 'third'}
        for @i in (1..3)
            begin
                api = RapleafApi::Api.new(apikey) # Set API key here
                hash = api.query_by_sha1(Digest::SHA1.hexdigest(@FortuneTeller.email))
                @facts = hash
                break;
            rescue Exception => e
                @errormessages << "Can't see you through the crystal ball in the " + count_in_english[i] + " time..." + e.message + ". You used '" + @FortuneTeller.email + "' as your email."
            end
        end
        
        #First get predictions on the user:
        stock = "You have a great need for other people to like and admire you. You have a tendency to be critical of yourself. You have a great deal of unused capacity which you have not turned to your advantage. While you have some personality weaknesses, you are generally able to compensate for them. Disciplined and self-controlled outside, you tend to be worrisome and insecure inside. At times you have serious doubts as to whether you have made the right decision or done the right thing. You prefer a certain amount of change and variety and become dissatisfied when hemmed in by restrictions and limitations. You pride yourself as an independent thinker and do not accept others' statements without satisfactory proof. You have found it unwise to be too frank in revealing yourself to others. At times you are extroverted, affable, sociable, while at other times you are introverted, wary, reserved. Some of your aspirations tend to be pretty unrealistic. Security is one of your major goals in life."
        stock = stock.split(".")
        stock.each_with_index {|value, index| stock[index] = value.strip }
        lines = Array.new
        unless hash.nil? || hash.length <= 0
            hash.each do|field, value|
                case field
                when "age"
                    case value[0]
                    when '1'
                        age = 'twenties'
                    when '2'
                        age = 'thirties'
                    when '3'
                        age = 'forties'
                    when '4'
                        age = 'fifties'
                    when '5'
                        age = 'sixties'
                    when '6'
                        age = 'seventies'
                    else
                        age = 'adulthood'
                    end
                    lines << "You are approaching your " + age
                when "gender"
                    if  value.casecmp("female") == 0
                        lines << "You are a nice lady"
                    else
                        lines << "You are a nice man"
                    end
                end            
            end
        end
        lines |= stock
        
        # Get intelligence, retry 3 times to counteract random error
        unless @FortuneTeller.dataset.strip == ''   #Don't query if it is empty
            for i in (1..3)
                begin               
                    set = Array.new
                    @FortuneTeller.dataset.each_line{|x| set << {'email' => x.strip}}
                    beginning_time = Time.now
                    @bulk = api.bulk_query(set, show_available = true)
                    end_time = Time.now
                    @timelapse = end_time - beginning_time
                    break
                rescue Exception => e
                    @errormessages << "Can't see your friends through the crystal ball in the " + count_in_english[i] + " time..." + e.message
                end
            end
        end
        # Process intelligence
        unless @bulk.nil? || @bulk.length == 0
            # Count the top
            @summary = {}
            @bulk.each do |person|
                person.each do |key,value|
                    if @summary[key].nil?
                        @summary[key] = {value => 1}
                    else
                        if @summary[key][value].nil?
                            @summary[key][value] = 1
                        else
                            @summary[key][value] += 1
                        end
                    end
                end
            end
            @tops = {}
            @available = Array.new
            Marshal.load(Marshal.dump(@summary)).each do |key,value|    #deep clone
                unless key.include? 'error'
                    value.delete("Data Available")
                    pop = value.max_by {|key, val| val}
                    if pop.nil?
                        @available << key.gsub(/[_]/, ' ')
                    else
                        @tops[key] = pop.first
                    end
                end
            end
        end

        friendsLines = Array.new
        unless @tops.nil?
            unless @tops['gender'].nil?
                friendsLines << "You prefer in company with " + @tops['gender'] + 's'
            end
            unless @tops['age'].nil?
                case @tops['age'][0]
                when '1'
                    age = 'twenties'
                when '2'
                    age = 'thirties'
                when '3'
                    age = 'forties'
                when '4'
                    age = 'fifties'
                when '5'
                    age = 'sixties'
                when '6'
                    age = 'seventies'
                else
                    age = 'adulthood'
                end
                friendsLines << "Your friends are approaching their " + age
            end
        end         
        
         # Merge all the predictions
            lines |= friendsLines
            lines = lines.shuffle
            
        # Creep them out with available fields
        unless @available.nil? || @available.length <= 0
            lines << "I also have a faint feeling about your friends' " + @available.to_sentence + ". But I am too weak to see them at the moment"
        end
        @lines = lines.join(". ") + "."
        @debug = lines.inspect
        
        respond_to do |format|
            format.html # show.html.erb
            format.json { render json: @consulting }
        end
    end
end
