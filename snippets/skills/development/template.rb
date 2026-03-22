gem "perron" unless File.read("Gemfile").include?("perron")

after_bundle do
  unless File.exist?("config/initializers/perron.rb")
    rails_command "perron:install"
  end

  {{files}}

  %w[.opencode .claude .gemini].each do |folder|
    destination = File.join(folder, "skills/perron")

    if File.directory?(File.join(destination_root, folder))
      FileUtils.mkdir_p(File.join(destination_root, destination))

      copy_file "#{__dir__}/../SKILL.md", File.join(destination, "SKILL.md")

      say "Add Perron skill for #{folder.delete_prefix(".").humanize}"
    end
  end
end
