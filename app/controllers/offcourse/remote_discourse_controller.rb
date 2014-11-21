module Offcourse
  class RemoteDiscourseController  < Offcourse::ApplicationController
    # ApplicationController
    layout false

    def site_details
      unless(params[:host] )
        return render json: {"error" => {"message" => "incorrect params"}}
      end
      #   binding.pry

      # if params[:host] == "/"
      #   @about = About.new
      #   # about_json = render_serialized(@about, AboutSerializer)
      #   # above causes a 'circular dependency error'
      #   about_json = JSON.parse('{"hello": "goodbye"}')
      #   binding.pry
      # end

      conn = connection params[:host]
      response = conn.get '/about.json'     # GET http://sushi.com/nigiri/sake.json
      rb = response.body
      if response.status == 200
        about_json = (JSON.parse response.body)['about']
        about_json['host_url'] = params[:host]
        return render json: about_json
      else
        return render json: {"error" => {"message" => "sorry, there has been an error"}}
      end

    end

    def categories
      unless(params[:host] )
        return render json: {"error" => {"message" => "incorrect params"}}
      end
      conn = connection params[:host]
      pass_through_request conn, "/categories.json"
    end

    def topics_per_category
      unless(params[:host] && params[:category] )
        return render json: {"error" => {"message" => "incorrect params"}}
      end
      conn = connection params[:host]

      # Faraday.new(:url => params[:host]) do |faraday|
      #   faraday.request  :url_encoded             # form-encode POST params
      #   faraday.response :logger                  # log requests to STDOUT
      #   faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      # end

      # response = conn.get '/c/' + params[:category] + '.json'     # GET http://sushi.com/nigiri/sake.json
      # rb = response.body
      # if response.status == 200
      #   return render json: response.body
      # else
      #   return render json: {"error" => {"message" => "incorrect params"}}
      # end
      path = '/c/' + params[:category] + '.json'
      pass_through_request conn, path
    end

    def topic_details
      unless(params[:host] && params[:topic_id] )
        return render json: {"error" => {"message" => "incorrect params"}}
      end
      conn = connection params[:host]

      path = '/t/' + params[:topic_id] + '.json'
      pass_through_request conn, path
    end


    private

    def pass_through_request conn, path
      response = conn.get path
      rb = response.body
      if response.status == 200
        return render json: response.body
      else
        return render json: {"error" => {"message" => "sorry, there has been an error"}}
      end
    end

    # https://github.com/discourse/discourse_api/blob/master/lib/discourse_api/client.rb
    def connection url
      # @connection ||= Faraday.new connection_options do |conn|
      faraday_connection = Faraday.new(:url => url) do |conn|
        # Follow redirects
        # conn.use FaradayMiddleware::FollowRedirects, limit: 5
        conn.response :logger                  # log requests to STDOUT
        # Convert request params to "www-form-encoded"
        conn.request :url_encoded
        # Parse responses as JSON
        # conn.use FaradayMiddleware::ParseJson, content_type: 'application/json'
        # Use Faraday's default HTTP adapter
        conn.adapter Faraday.default_adapter
        #pass api_key and api_username on every request
        # conn.params['api_key'] = api_key
        # conn.params['api_username'] = api_username
      end
    end

    # def request(method, path, params={})
    #   response = connection.send(method.to_sym, path, params)
    #   response.env
    # rescue Faraday::Error::ClientError, JSON::ParserError
    #   raise DiscourseApi::Error
    # end



  end
end
