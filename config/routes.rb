Offcourse::Engine.routes.draw do
  get "/offcourse" => "offcourse#online"
  get "/offcourse/online" => "offcourse#online"
  get "/offcourse/online/*path" => "offcourse#online"
  get "/offcourse/topics" => "offcourse#offline"
  get "/offcourse/topics/*path" => "offcourse#offline"
  get "/remote_discourse/categories" => "remote_discourse#categories"
end
