ActiveSupport.on_load :before_configuration, :yield => true do
  RailsConfig.setup do |config|
    config.const_name = "Settings"
  end
end