module Rblox
  class Token
    attr_reader :type, :lexeme, :literal, :line

    def initialize(type, lexeme, literal, line)
      @type = type
      @lexeme = lexeme
      @literal = literal
      @line = line
    end

    def to_s
      "#{type} #{lexeme} #{literal}"
    end

    def ==(other)
      type == other.type &&
      lexeme == other.lexeme &&
      literal == other.literal &&
      line == other.line
    end
  end
end
