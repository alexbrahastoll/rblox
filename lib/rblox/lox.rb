module Rblox
  class Lox
    attr_reader :args

    def initialize(args)
      @args = args
    end

    def start
      if args.length > 1
        puts 'Usage: rblox [script]'
      elsif args.length == 1
        run_file(args[0])
      else
        run_repl
      end
    end

    def run_file(path)
      source = File.read(path)
      run(source)
    end

    def run_repl
      loop do
        print '> '
        line = gets
        line = line.chomp if line
        next if line == ''

        run(line)
      end
    end

    def run(source)
      scanner = Scanner.new(source)
      tokens = scanner.scan_tokens

      puts tokens.join(' ')
    end
  end
end
