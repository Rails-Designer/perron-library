gem "importmap-rails" unless File.read("Gemfile").include?("importmap")
gem "perron" unless File.read("Gemfile").include?("perron")
gem "tailwindcss-rails" unless File.read("Gemfile").include?("tailwindcss-rails")

after_bundle do
  unless File.exist?("config/importmap.rb")
    rails_command "importmap:install"
  end

  unless File.exist?("config/initializers/perron.rb")
    rails_command "perron:install"
  end

  unless File.exist?("app/assets/tailwind/application.css")
    rails_command "tailwindcss:install"
  end

  {{files}}
end
