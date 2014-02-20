require 'ruby-prof'

def measure(name, count, &block)
  should "#{name} (#{count}x)" do
    RubyProf.start

    count.times do
      block.call
    end

    result = RubyProf.stop
    printer = RubyProf::FlatPrinter.new(result)
    printer.print(STDOUT)
  end
end
