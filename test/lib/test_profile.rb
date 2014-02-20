require 'ruby-prof'

def measure(name, count, &block)
  should "#{name} (#{count}x)" do
    RubyProf.start

    count.times do
      block.call
    end

    result = RubyProf.stop
    printer = RubyProf::MultiPrinter.new(result)
    printer.print(path: 'tmp')
  end
end
