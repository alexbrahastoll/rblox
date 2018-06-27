module Rblox
  class Scanner
    attr_reader :source, :start, :current, :line, :tokens

    def initialize(source)
      @source = source
      @start = 0
      @current = 0
      @line = 1
      @tokens = []
    end

    def scan_tokens
      # puts source
      # ['Not implemented yet.']

      while !at_end?
        start = current
        scan_token
      end

      tokens << Token.new(TokenType::EOF, '', nil, line)
    end

    private

    attr_writer :start, :current, :line

    def at_end?
      current >= source.length
    end

    def scan_token
      c = advance
      case c
      when '('
        add_token(TokenType::LEFT_PAREN)
      when ')'
        add_token(TokenType::RIGHT_PAREN)
      when '{'
        add_token(TokenType::LEFT_BRACE)
      when '}'
        add_token(TokenType::RIGHT_BRACE)
      when ','
        add_token(TokenType::COMMA)
      when '.'
        add_token(TokenType::DOT)
      when '-'
        add_token(TokenType::MINUS)
      when '+'
        add_token(TokenType::PLUS)
      when ';'
        add_token(TokenType::SEMICOLON)
      when '*'
        add_token(TokenType::STAR)
      when '!'
        add_token(match?('=') ? TokenType::BANG_EQUAL : TokenType::BANG)
      when '='
        add_token(match?('=') ? TokenType::EQUAL_EQUAL : TokenType::EQUAL)
      when '<'
        add_token(match?('=') ? TokenType::LESS_EQUAL : TokenType::LESS)
      when '>'
        add_token(match?('=') ? TokenType::GREATER_EQUAL : TokenType::GREATER)
      else
        Lox.error(line, 'Unexpected character.')
      end
    end

    def advance
      c = source[current]
      current += 1
      c
    end

    def add_token(type, literal = nil)
      text = source[start, current]
      tokens << Token.new(type, text, literal, line)
    end

    def match?(expected)
      return false if at_end?
      return false if source[current] != expected

      current += 1
      true
    end
  end
end
