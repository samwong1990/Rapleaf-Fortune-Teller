class ConsultingsController < ApplicationController
    def about
    end
    
    # GET /consultings
    # GET /consultings.json
    def index
        # @consultings = Consulting.all

        respond_to do |format|
            format.html # index.html.erb
            format.json { render json: @consultings }
        end
    end

    # GET /consultings/1
    # GET /consultings/1.json
    def show
        # @consulting = Consulting.find(params[:id])
        @consulting = Consulting.find_last_by_session(session[:session_id])

        respond_to do |format|
            format.html # show.html.erb
            format.json { render json: @consulting }
        end
    end

    # GET /consultings/new
    # GET /consultings/new.json
    def new
        @consulting = Consulting.new

        respond_to do |format|
            format.html # new.html.erb
            format.json { render json: @consulting }
        end
    end

    # GET /consultings/1/edit
    def edit
        @consulting = Consulting.find(params[:id])
    end

    # POST /consultings
    # POST /consultings.json
    def create
        params[:consulting]['session'] = session[:session_id]
        hashedEmails = Array.new
        params[:consulting]['dataset'].each_line do |email|
            hashedEmails << Digest::SHA1.hexdigest(email.strip)
        end
        params[:consulting]['hasheddataset'] = hashedEmails.join("\n")
        @consulting = Consulting.new(params[:consulting])

        respond_to do |format|
            if @consulting.save
                format.html { redirect_to @consulting, notice: 'Consulting was successfully created.' }
                format.json { render json: @consulting, status: :created, location: @consulting }
            else
                format.html { render action: "new" }
                format.json { render json: @consulting.errors, status: :unprocessable_entity }
            end
        end
    end

    # PUT /consultings/1
    # PUT /consultings/1.json
    def update
        params[:consulting]['session'] = session[:session_id]
        hashedEmails = Array.new
        params[:consulting]['dataset'].each_line do |email|
            hashedEmails << Digest::SHA1.hexdigest(email.strip)
        end
        params[:consulting]['hasheddataset'] = hashedEmails.join("\n")
        # @consulting = Consulting.find(params[:id])
        @consulting = Consulting.find_by_session(session[:session_id])

        respond_to do |format|
            if @consulting.update_attributes(params[:consulting])
                format.html { redirect_to @consulting, notice: 'Consulting was successfully updated.' }
                format.json { head :ok }
            else
                format.html { render action: "edit" }
                format.json { render json: @consulting.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /consultings/1
    # DELETE /consultings/1.json
    def destroy
        @consulting = Consulting.find(params[:id])
        @consulting.destroy
        respond_to do |format|
            format.html { redirect_to consultings_url }
            format.json { head :ok }
        end
    end

    def result
        @consulting = Consulting.find_last_by_session(session[:session_id])
        @errormessages = Array.new
        path_to_apikey = "APIKEY"
        apikey = IO.read(path_to_apikey).strip
        # Get intelligence, retry 3 times to counteract random errors
        count_in_english = { 1 => 'first', 2 => 'second', 3 => 'third'}
        for i in (1..3)
            begin               
                set = Array.new
                @consulting.dataset.each_line{|x| set << {'email' => x.strip}}
                beginning_time = Time.now
                api = RapleafApi::Api.new(apikey) # Set API key here
                @bulk = api.bulk_query(set, show_available = true)
                end_time = Time.now
                @timelapse = end_time - beginning_time
                break
            rescue Exception => e
                @errormessages << "Can't see your customers through the crystal ball in the " + count_in_english[i] + " time... " + e.message
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

        niche = Array.new
        unless @tops.nil? || @tops.length == 0
            unless @tops['gender'].nil?
                niche << @tops['gender'].downcase + 's'
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
                niche << " in their " + age
            end
        end                 

        if niche.length == 0
            @niche = "Your niche is probably some secret societies, even my crystal ball doesn't know anything about them."
        else
            @niche = "Your niche is " + niche.join(" ") + "."
        end
        respond_to do |format|
            format.html # show.html.erb
            format.json { render json: @consulting }
        end
    end
end
