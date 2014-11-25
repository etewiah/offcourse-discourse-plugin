module Offcourse
  class RemoteDiscourseController  < Offcourse::ApplicationController
    # ApplicationController
    layout false
    # before_action :verify_host_param, except: [:get_or_add_site, :get_sites]


    def get_sites
      site_records = Offcourse::DiscourseSite.all
      return render json: site_records.as_json, root: false
    end

    def get_or_add_site
      if params[:slug]
        site_record = Offcourse::DiscourseSite.where(:slug => params[:slug]).first
        return render json: site_record.as_json

      else

        # TODO - calculate and use slug below to avoid say http & https confusion
        site_record = Offcourse::DiscourseSite.where(:base_url => params[:host]).first
        if site_record
          return render json: site_record.as_json
        else
          conn = connection params[:host]
          site_info = remote_site_info conn
          new_site = create_site_record site_info

          render json: new_site.as_json
        end
      end


    end

    def categories
      unless(params[:host] || params[:slug] )
        return render json: {"error" => {"message" => "incorrect params"}}
      end

      if params[:slug]
        site_record = Offcourse::DiscourseSite.where(:slug => params[:slug]).first
        host = site_record.base_url
      else
        site_record = Offcourse::DiscourseSite.where(:base_url => params[:host]).first
        host = site_record.base_url
        # host = params[:host]
      end

      conn = connection host
      # pass_through_request conn, "/categories.json"

      response = conn.get "/categories.json"
      rb = JSON.parse response.body

      if (response.status == 200) && rb["category_list"]
        return render json: { categories: rb["category_list"]["categories"],
                              site_details: site_record.as_json }
      else
        return render json: {"error" => {"message" => "sorry, there has been an error"}}
      end
    end

    def topics_per_category
      if params[:slug]
        site_record = Offcourse::DiscourseSite.where(:slug => params[:slug]).first
        host = site_record.base_url
      else
        host = params[:host]
      end

      unless(host && params[:category] )
        return render json: {"error" => {"message" => "incorrect params"}}
      end
      conn = connection host

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

    # def verify_host_param
    #   unless(params[:host] )
    #     return render json: {"error" => {"message" => "incorrect params"}}
    #   end
    # end

    def remote_site_info conn
      about_response = conn.get '/about.json'     # GET http://sushi.com/nigiri/sake.json
      rb = about_response.body
      if about_response.status == 200
        about_json = (JSON.parse about_response.body)['about']
        about_json['host_url'] = conn.url_prefix.to_s.downcase
        # params[:host]
        root_response = conn.get '/'
        page = Nokogiri::HTML(root_response.body)
        favicon_url = page.css('link[rel="icon"]')[0].attributes['href'].value rescue nil
        about_json['favicon_url'] = favicon_url
        apple_touch_icon_url = page.css('link[rel="apple-touch-icon"]')[0].attributes['href'].value rescue nil
        about_json['apple_touch_icon_url'] = apple_touch_icon_url
        return about_json
      else
        return {"error" => {"message" => "sorry, there has been an error"}}
      end
    end

    def create_site_record site_info
      uri = URI.parse site_info['host_url']
      new_site = Offcourse::DiscourseSite.where(:base_url => site_info['host_url']).first_or_initialize
      new_site.meta = site_info
      new_site.slug = uri.hostname.gsub( ".","_")
      new_site.display_name = site_info['title']
      new_site.description = site_info['description']
      new_site.logo_url = site_info['favicon_url']
      new_site.save!
      return new_site
    end

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
