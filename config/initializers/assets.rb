# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
# Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w( admin_login.css.scss admin_login.js dashboard.css.scss dashboard.js )

%w( admin/admins admin/settings admin/sections admin/hrs admin/holidays admin/recruitments admin/employees admin/roles admin/rooms admin/attendances admin/vacation_requests admin/notifications admin/updates admin/messages admin/timelines admin/performance_topics ).each do |controller|
  Rails.application.config.assets.precompile += ["#{controller}.css.scss", "#{controller}.js"]
end
