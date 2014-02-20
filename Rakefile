require 'bundler/setup'

task default: 'test:unit'
task test:    'test:unit'

require 'rake/testtask'
namespace :test do
  Rake::TestTask.new(:unit) do |test|
    test.pattern = "test/unit/*_test.rb"
    test.libs << 'lib'
    test.libs << 'test'
  end

  Rake::TestTask.new(:profile) do |test|
    test.pattern = "test/profile/*_test.rb"
    test.libs << 'lib'
    test.libs << 'test'
    test.libs << 'test/lib'
  end
end
