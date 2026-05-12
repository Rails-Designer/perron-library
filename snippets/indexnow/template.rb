gem "perron" unless File.read("Gemfile").include?("perron")

after_bundle do
  unless File.exist?("config/initializers/perron.rb")
    rails_command "perron:install"
  end

key = SecureRandom.hex

file "public/#{key}.txt", <<-KEY
#{key}
KEY
end
