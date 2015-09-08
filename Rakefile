namespace :profile do
  require_relative "profile/profile"

  task :normalize_url do |task|
    require "twingly/url/normalizer"

    Profile.measure "normalizing a short URL", 1000 do
      Twingly::URL::Normalizer.normalize_url('http://www.duh.se/')
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
