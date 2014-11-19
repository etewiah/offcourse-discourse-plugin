module Offcourse
  class RemoteDiscourseController < ApplicationController
    layout false
    def categories
      unless(params[:host] )
        return render json: {"error" => {"message" => "sorry, there has been an error"}}
      end

      conn = Faraday.new(:url => params[:host]) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end

      ## GET ##

      response = conn.get '/categories.json'     # GET http://sushi.com/nigiri/sake.json
      rb = response.body
      if response.status == 200
        return render json: response.body      
      else
        return render json: {"error" => {"message" => "sorry, there has been an error"}}
      end
    end

    def topics_per_category
      unless(params[:host] && params[:category] )
        return render json: {"error" => {"message" => "sorry, there has been an error"}}
      end

      conn = Faraday.new(:url => params[:host]) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end

      ## GET ##

      response = conn.get '/c/' + params[:category] + '.json'     # GET http://sushi.com/nigiri/sake.json
      rb = response.body
      if response.status == 200
        return render json: response.body      
      else
        return render json: {"error" => {"message" => "sorry, there has been an error"}}
      end
    end

    def topic_details
      unless(params[:host] && params[:topic_id] )
        return render json: {"error" => {"message" => "sorry, there has been an error"}}
      end

      conn = Faraday.new(:url => params[:host]) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end

      ## GET ##

      response = conn.get '/t/' + params[:topic_id] + '.json'     # GET http://sushi.com/nigiri/sake.json
      rb = response.body
      if response.status == 200
        return render json: response.body      
      else
        return render json: {"error" => {"message" => "sorry, there has been an error"}}
      end
    end

  end
end
