# frozen_string_literal: true

# Bundler rake tasks to handle gem releases
require "bundler/gem_tasks"

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

  task default: spec_tasks.shuffle
rescue LoadError
end
