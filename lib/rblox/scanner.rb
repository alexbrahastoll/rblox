module Rblox
  class Scanner
    KEYWORDS = {
      'and'    => TokenType::AND,
      'class'  => TokenType::CLASS,
      'else'   => TokenType::ELSE,
      'false'  => TokenType::FALSE,
      'for'    => TokenType::FOR,
      'fun'    => TokenType::FUN,
      'if'     => TokenType::IF,
      'nil'    => TokenType::NIL,
      'or'     => TokenType::OR,
      'print'  => TokenType::PRINT,
      'return' => TokenType::RETURN,
      'super'  => TokenType::SUPER,
      'this'   => TokenType::THIS,
      'true'   => TokenType::TRUE,
      'var'    => TokenType::VAR,
      'while'  => TokenType::WHILE
    }

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
      when '/'
        if match?('/')
          # A comment goes until the end of the line.
          while peek != "\n" && !at_end?
            advance
          end
        else
          add_token(TokenType::SLASH)
        end
      when ' ' || "\r" || "\t"
        # Ignore whitespace.
      when "\n"
        line += 1
      when '"'
        string
      when digit?(c)
        number
      when alpha_numeric?(c)
        identifier
      else
        Lox.error(line, 'Unexpected character.')
      end
    end

    def string
      while peek != '"' && !at_end?
        line += 1 if peek == "\n"
        advance
      end

      # Unterminated string.
      if at_end?
        Lox.error(line, 'Unterminated string.')
        return
      end

      # The closing ".
      advance

      # Trim the surrounding quotes to produce the actual value of the string.
      value = source[(start + 1)..(current - 2)]
      add_token(TokenType::STRING, value)
    end

    def number
      while digit?(peek)
        advance
      end

      # Look for a fractional part.
      if peek == '.' && digit?(peek_next)
        advance
        while digit?(peek)
          advance
        end
      end

      value = source[start..(current - 1)]
      add_token(TokenType::NUMBER, value.to_f)
    end

    def identifier
      while alpha_numeric?(peek)
        advance
      end

      # Check to see if the identifier is a reserved word.
      text = source[start, (current - 1)]
      token_type = KEYWORDS[text]
      token_type ||= TokenType::IDENTIFIER

      add_token(token_type)
    end

    def add_token(type, literal = nil)
      text = source[start..(current - 1)]
      tokens << Token.new(type, text, literal, line)
    end

    def digit?(char)
      char >= '0' && char <= '9'
    end

    def alpha?(char)
      char >= 'a' && char <= 'z' ||
      char >= 'A' && char <= 'Z' ||
      char == '_'
    end

    def alpha_numeric?(char)
      alpha?(char) || digit?(char)
    end

    def at_end?
      current >= source.length
    end

    def advance
      c = source[current]
      current += 1
      c
    end

    def match?(expected)
      return false if at_end?
      return false if source[current] != expected

      current += 1
      true
    end

    def peek
      return "\0" if at_end?
      source[current]
    end

    def peek_next
      return "\0" if (current + 1) >= source.length
      source[current + 1]
    end
  end
end
