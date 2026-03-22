gem "perron" unless File.read("Gemfile").include?("perron")

after_bundle do
  unless File.exist?("config/initializers/perron.rb")
    rails_command "perron:install"
  end

  run "npm install -g surge"

  {{files}}

  run "chmod +x bin/deploy"
end
