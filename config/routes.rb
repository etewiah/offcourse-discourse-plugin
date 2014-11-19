Offcourse::Engine.routes.draw do
  get "/offcourse" => "offcourse#online"
  get "/offcourse/online" => "offcourse#online"
  get "/offcourse/online/*path" => "offcourse#online"
  get "/offcourse/topics" => "offcourse#offline"
  get "/offcourse/topics/*path" => "offcourse#offline"
  get "/remote_discourse/categories" => "remote_discourse#categories"
  get "/remote_discourse/topics_per_category" => "remote_discourse#topics_per_category"
  get "/remote_discourse/topic_details" => "remote_discourse#topic_details"
end
