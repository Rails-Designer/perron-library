gem "importmap-rails" unless File.read("Gemfile").include?("importmap")
gem "perron" unless File.read("Gemfile").include?("perron")

after_bundle do
  unless File.exist?("config/importmap.rb")
    rails_command "importmap:install"
  end

  unless File.exist?("config/initializers/perron.rb")
    rails_command "perron:install"
  end

  route "resource :search, module: :perron, path: \"search.json\", only: %w[show]"

  insert_into_file "config/initializers/perron.rb", "\n  config.search_scope = []\n", after: "Perron.configure do |config|"

  create_file "app/javascript/components/index.js", <<~JS, skip: true
  import "components/search_form"
  JS

  application_js_path = "app/javascript/application.js"
  if File.exist?(application_js_path)
    insert_into_file application_js_path, "\nimport \"components\"\n", after: /\A(?:import .+\n)*/
  else
    create_file application_js_path, <<~JS
  import "components"
  JS
  end

  unless File.exist?("config/importmap.rb")
    say "Warning: importmap.rb not found!", :yellow
    say "Please set up importmap-rails first by running:"
    say "  rails importmap:install"
    say "Or use your preferred JavaScript set up."

    return
  end

  run "bin/importmap pin minisearch"
  run "bin/importmap pin tinykeys"

  insert_into_file "config/importmap.rb", after: /\A.*pin .+\n+/m do
    "\npin_all_from \"app/javascript/components\", under: \"components\"\npin_all_from \"app/javascript/helpers\", under: \"helpers\"\n"
  end

  {{files}}
end
