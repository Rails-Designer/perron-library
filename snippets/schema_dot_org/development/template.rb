gem "perron" unless File.read("Gemfile").include?("perron")

gem "schema_dot_org", "~> 2.5" unless File.read("Gemfile").include?("schema_dot_org")

after_bundle do
  unless File.exist?("config/initializers/perron.rb")
    rails_command "perron:install"
  end

  {{files}}
end
