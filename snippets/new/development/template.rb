gem "perron" unless File.read("Gemfile").include?("perron")

after_bundle do
  unless File.exist?("config/initializers/perron.rb")
    rails_command "perron:install"
  end

end
gem "perron" unless File.read("Gemfile").include?("perron")

after_bundle do
  unless File.exist?("config/initializers/perron.rb")
    rails_command "perron:install"
  end

  gsub_file "Gemfile", /gem "sqlite3".*$/, ""
  gsub_file "Gemfile", /gem "activerecord".*$/, ""

  remove_file "config/database.yml"
  remove_file "config/credentials.yml.enc"
  remove_file "config/master.key"

  remove_file "public/400.html"
  remove_file "public/406-unsupported-browser.html"
  remove_file "public/422.html"
  remove_file "public/500.html"

  remove_file "app/controllers/application_controller.rb"
  remove_file "app/views/layouts/application.html.erb"
  remove_file "README.md"

  run "rm -r app/views/pwa"

  append_to_file ".gitignore", "/output/\n"

  # “Reset” ApplicationController
  create_file "app/controllers/application_controller.rb", <<~RB
  class ApplicationController < ActionController::Base
  end
  RB

  {{files}}

  markdown_gem = ask("Which markdown parser would you like to use? (commonmarker/kramdown/redcarpet or leave blank to skip):")

  VALID_MARKDOWN_GEMS = %w[commonmarker kramdown redcarpet]

  gem_name = markdown_gem.strip.downcase
  if VALID_MARKDOWN_GEMS.include?(gem_name)
    uncomment_lines "Gemfile", /gem "#{gem_name}"/

    Bundler.with_unbundled_env { run "bundle install" }
  elsif markdown_gem.present?
    say "Invalid markdown parser option. Skipping…", :yellow
  end
end
