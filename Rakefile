require "bundler/gem_tasks"

namespace :profile do
  require_relative "profile/profile"

  desc "Profile"
  task :normalize do |task|
    require_relative "lib/twingly/url"

    Profile.measure "normalizing a short URL", 1000 do
      Twingly::URL.parse('http://www.duh.se/').normalized
    end
  end
end

begin
  require "rspec/core/rake_task"

  spec_files = Dir.glob(File.join("spec/**", "*_spec.rb"))
  spec_tasks = []

  namespace(:spec) do
    spec_files.each do |spec_file|
      task_name = File.basename(spec_file, ".rb").to_sym

      spec_tasks << "spec:#{task_name}"

      RSpec::Core::RakeTask.new(task_name) do |task|
        task.pattern = spec_file
      end
    end
  end

  require "coveralls/rake/task"
  Coveralls::RakeTask.new

  desc "Run all tests with code coverage analysis"
  task :default do
    begin
      spec_tasks.shuffle.each do |task_name|
        Rake::Task[task_name].invoke
      end
    ensure
      Rake::Task["coveralls:push"].invoke
    end
  end
rescue LoadError
end
