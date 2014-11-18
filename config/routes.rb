Offcourse::Engine.routes.draw do
  get "/offcourse" => "offcourse#online"
  get "/offcourse/online" => "offcourse#online"
  get "/offcourse/online/*path" => "offcourse#online"
  get "/offcourse/topics" => "offcourse#offline"
end
