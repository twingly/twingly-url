# frozen_string_literal: true

require "ruby-prof"
require "memory_profiler"

class Profile
  def self.measure(name, count, &block)
    RubyProf.start

    count.times do
      block.call
    end

    result = RubyProf.stop
    result_directory = "tmp"
    Dir.mkdir(result_directory) unless File.exists?(result_directory)
    printer = RubyProf::MultiPrinter.new(result)
    printer.print(path: result_directory)

    puts "Measured #{name} #{count} times"
    puts "Generated reports:"
    Dir.entries(result_directory).reject { |entry| entry.end_with?(".") }.each do |file|
      puts "  #{result_directory}/#{file}"
    end
  end
end

class MemoryProfile
  def self.measure(name, count, &block)
    report_options = {
      ignore_files: __FILE__ # Ignore this file
    }

    MemoryProfiler.start(report_options)

    count.times do
      block.call
    end

    report = MemoryProfiler.stop
    report.pretty_print
  end
end
