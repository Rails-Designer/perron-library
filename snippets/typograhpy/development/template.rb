gem "perron" unless File.read("Gemfile").include?("perron")

after_bundle do
  unless File.exist?("config/initializers/perron.rb")
    rails_command "perron:install"
  end

  if File.exist?("app/assets/tailwind/application.css")
    insert_into_file "app/assets/tailwind/application.css", "@import ./components/content"
  end

  {{files}}
end
