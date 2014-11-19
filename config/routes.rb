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
end
