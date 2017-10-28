module Rblox
  class Lox
    attr_reader :args

    @@had_error = false

    def initialize(args)
      @args = args
    end

    def self.error(line, msg)
      report(line, '', msg)
    end

    def self.report(line, where, msg)
      puts "[line #{line}] Error#{where}: #{msg}"
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
      exit(65) if @@had_error
    end

    def run_repl
      loop do
        print '> '
        line = gets
        line = line.chomp if line
        next if line == ''

        run(line)
        # We should not abort the REPL if the line evaluation results in
        # an error.
        @@had_error = false
      end
    end

    def run(source)
      scanner = Scanner.new(source)
      tokens = scanner.scan_tokens

      puts tokens.join(' ')
    end
  end
end
