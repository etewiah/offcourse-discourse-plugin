Offcourse::Engine.routes.draw do
  get "/offcourse" => "offcourse#online"
  get "/offcourse/retrieve" => "offcourse#online"
  get "/offcourse/retrieve/*path" => "offcourse#online"
  # below has manifest declared
  get "/offcourse/offline" => "offcourse#index"
  get "/offcourse/offline/*path" => "offcourse#index"
  get "/remote_discourse/categories" => "remote_discourse#categories"
  get "/remote_discourse/topics_per_category" => "remote_discourse#topics_per_category"
  get "/remote_discourse/topic_details" => "remote_discourse#topic_details"

  # get "/remote_discourse/site_details" => "remote_discourse#site_details"
  get "/remote_discourse/get_or_add_site" => "remote_discourse#get_or_add_site"
  get "/remote_discourse/get_sites" => "remote_discourse#get_sites"

end
