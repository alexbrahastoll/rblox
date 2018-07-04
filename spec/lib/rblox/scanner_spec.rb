require 'spec_helper'

RSpec.describe Rblox::Scanner do
  describe '#scan_tokens' do
    context 'when the source only contains valid lexemes' do
      it 'does produce the appropriate tokens' do
        source = <<-RBLOX
          and class else false for fun if nil or print return super this true
          var while ( ) { } , . - + ; * ! != = < <= > >= /
          // A comment.
          "A multi-line
          string." "A string." 12 12.34 myvar myvar1 my_var my_var1
        RBLOX
        scanner = Rblox::Scanner.new(source)
        expected_tokens = [
          Rblox::Token.new(Rblox::TokenType::AND, 'and', nil, 1),
          Rblox::Token.new(Rblox::TokenType::CLASS, 'class', nil, 1),
          Rblox::Token.new(Rblox::TokenType::ELSE, 'else', nil, 1),
          Rblox::Token.new(Rblox::TokenType::FALSE, 'false', nil, 1),
          Rblox::Token.new(Rblox::TokenType::FOR, 'for', nil, 1),
          Rblox::Token.new(Rblox::TokenType::FUN, 'fun', nil, 1),
          Rblox::Token.new(Rblox::TokenType::IF, 'if', nil, 1),
          Rblox::Token.new(Rblox::TokenType::NIL, 'nil', nil, 1),
          Rblox::Token.new(Rblox::TokenType::OR, 'or', nil, 1),
          Rblox::Token.new(Rblox::TokenType::PRINT, 'print', nil, 1),
          Rblox::Token.new(Rblox::TokenType::RETURN, 'return', nil, 1),
          Rblox::Token.new(Rblox::TokenType::SUPER, 'super', nil, 1),
          Rblox::Token.new(Rblox::TokenType::THIS, 'this', nil, 1),
          Rblox::Token.new(Rblox::TokenType::TRUE, 'true', nil, 1),
          Rblox::Token.new(Rblox::TokenType::VAR, 'var', nil, 2),
          Rblox::Token.new(Rblox::TokenType::WHILE, 'while', nil, 2),
          Rblox::Token.new(Rblox::TokenType::LEFT_PAREN, '(', nil, 2),
          Rblox::Token.new(Rblox::TokenType::RIGHT_PAREN, ')', nil, 2),
          Rblox::Token.new(Rblox::TokenType::LEFT_BRACE, '{', nil, 2),
          Rblox::Token.new(Rblox::TokenType::RIGHT_BRACE, '}', nil, 2),
          Rblox::Token.new(Rblox::TokenType::COMMA, ',', nil, 2),
          Rblox::Token.new(Rblox::TokenType::DOT, '.', nil, 2),
          Rblox::Token.new(Rblox::TokenType::MINUS, '-', nil, 2),
          Rblox::Token.new(Rblox::TokenType::PLUS, '+', nil, 2),
          Rblox::Token.new(Rblox::TokenType::SEMICOLON, ';', nil, 2),
          Rblox::Token.new(Rblox::TokenType::STAR, '*', nil, 2),
          Rblox::Token.new(Rblox::TokenType::BANG, '!', nil, 2),
          Rblox::Token.new(Rblox::TokenType::BANG_EQUAL, '!=', nil, 2),
          Rblox::Token.new(Rblox::TokenType::EQUAL, '=', nil, 2),
          Rblox::Token.new(Rblox::TokenType::LESS, '<', nil, 2),
          Rblox::Token.new(Rblox::TokenType::LESS_EQUAL, '<=', nil, 2),
          Rblox::Token.new(Rblox::TokenType::GREATER, '>', nil, 2),
          Rblox::Token.new(Rblox::TokenType::GREATER_EQUAL, '>=', nil, 2),
          Rblox::Token.new(Rblox::TokenType::SLASH, '/', nil, 2),
          Rblox::Token.new(Rblox::TokenType::STRING, "\"A multi-line\n          string.\"", "A multi-line\n          string.", 4),
          Rblox::Token.new(Rblox::TokenType::STRING, "\"A string.\"", 'A string.', 5),
          Rblox::Token.new(Rblox::TokenType::NUMBER, '12', 12.0, 5),
          Rblox::Token.new(Rblox::TokenType::NUMBER, '12.34', 12.34, 5),
          Rblox::Token.new(Rblox::TokenType::IDENTIFIER, 'myvar', nil, 5),
          Rblox::Token.new(Rblox::TokenType::IDENTIFIER, 'myvar1', nil, 5),
          Rblox::Token.new(Rblox::TokenType::IDENTIFIER, 'my_var', nil, 5),
          Rblox::Token.new(Rblox::TokenType::IDENTIFIER, 'my_var1', nil, 5),
          Rblox::Token.new(Rblox::TokenType::EOF, '', nil, 6)
        ]

        tokens = scanner.scan_tokens

        expect(tokens).to eq(expected_tokens)
      end
    end

    context 'when the source contains invalid lexemes' do
      it 'does produce an error' do
        source = "myvar = 1;\n@"
        scanner = Rblox::Scanner.new(source)

        expect(Rblox::Lox).to receive(:error).with(2, 'Unexpected character.')

        scanner.scan_tokens
      end
    end
  end
end
