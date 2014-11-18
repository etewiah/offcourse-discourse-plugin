# name: Offcourse
# about: Klavado's Offcourse plugin for Discourse
# version: 0.1
# authors: Ed Tewiah

# load the engine
load File.expand_path('../lib/offcourse/engine.rb', __FILE__)

# register_asset "javascripts/discourse/templates/components/home-logo.js.handlebars"
# register_asset "javascripts/discourse/templates/site_map.js.handlebars"
# register_asset "stylesheets/offcourse.scss", :desktop
# register_asset "stylesheets/offcourse.scss", :mobile


# And mount the engine
Discourse::Application.routes.append do
    mount Offcourse::Engine, at: '/'
end

# after_initialize do
#   require_dependency File.expand_path('../integrate_location_topic.rb', __FILE__)
# end
