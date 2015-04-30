require 'ruby-prof'

def measure(name, count, &block)
  should "#{name} (#{count}x)" do
    RubyProf.start

    count.times do
      block.call
    end

    result = RubyProf.stop
    result_directory = "tmp"
    Dir.mkdir(result_directory) unless File.exists?(result_directory)
    printer = RubyProf::MultiPrinter.new(result)
    printer.print(path: result_directory)
  end
end
