require "ruby-prof"

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
