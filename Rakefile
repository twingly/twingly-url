namespace :profile do
  require_relative "profile/profile"

  desc "Profile"
  task :normalize do |task|
    require "twingly/url"

    Profile.measure "normalizing a short URL", 1000 do
      Twingly::URL.parse('http://www.duh.se/').normalized
    end
  end
end

begin
  require "rspec/core/rake_task"

  task default: "spec"

  RSpec::Core::RakeTask.new(:spec) do |task|
    task.pattern = "spec/lib/**/*_spec.rb"
  end
rescue LoadError
end
