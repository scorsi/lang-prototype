class Parser

token if
token def
token class
token newline
token number
token string
token true false nil
token identifier
token constant
token indent dedent

prechigh
  left  '.'
  right '!'
  left  '*' '/'
  left  '+' '-'
  left  '>' '>=' '<' '<='
  left  '==' '!='
  left  '&&'
  left  '||'
  right '='
  left  ','
preclow

rule
  Program:
    /* nothing */                      { result = Nodes.new([]) }
  | Expressions                        { result = val[0] }
  ;

  Expressions:
    Expression                         { result = Nodes.new(val) }
  | Expressions Terminator Expression  { result = val[0] << val[2] }
  | Expressions Terminator             { result = val[0] }
  | Terminator                         { result = Nodes.new([]) }
  ;

  Expression:
    Literal
  | Call
  | Operator
  | GetConstant
  | SetConstant
  | GetLocal
  | SetLocal
  | Def
  | Class
  | If
  | '(' Expression ')'    { result = val[1] }
  ;

  Terminator:
    newline
  | ";"
  ;

  Literal:
    number                        { result = NumberNode.new(val[0]) }
  | string                        { result = StringNode.new(val[0]) }
  | true                          { result = TrueNode.new }
  | false                         { result = FalseNode.new }
  | nil                           { result = NilNode.new }
  ;

  Call:
    identifier Arguments          { result = CallNode.new(nil, val[0], val[1]) }
  | Expression "." identifier
      Arguments                   { result = CallNode.new(val[0], val[2], val[3]) }
  | Expression "." identifier     { result = CallNode.new(val[0], val[2], []) }
  ;

  Arguments:
    "(" ")"                       { result = [] }
  | "(" ArgList ")"               { result = val[1] }
  ;

  ArgList:
    Expression                    { result = val }
  | ArgList "," Expression        { result = val[0] << val[2] }
  ;


  Operator:
    Expression '||' Expression  { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '&&' Expression  { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '==' Expression  { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '!=' Expression  { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '>'  Expression  { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '>=' Expression  { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '<'  Expression  { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '<=' Expression  { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '+'  Expression  { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '-'  Expression  { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '*'  Expression  { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '/'  Expression  { result = CallNode.new(val[0], val[1], [val[2]]) }
  ;

  GetConstant:
    constant                      { result = GetConstantNode.new(val[0]) }
  ;

  SetConstant:
    constant "=" Expression       { result = SetConstantNode.new(val[0], val[2]) }
  ;

  GetLocal:
    identifier                    { result = GetLocalNode.new(val[0]) }
  ;

  SetLocal:
    identifier "=" Expression     { result = SetLocalNode.new(val[0], val[2]) }
  ;

  Block:
    indent Expressions dedent     { result = val[1] }
  ;

  Def:
    def identifier Block          { result = DefNode.new(val[1], [], val[2]) }
  | def identifier
      "(" ParamList ")" Block     { result = DefNode.new(val[1], val[3], val[5]) }
  ;

  ParamList:
    /* nothing */                 { result = [] }
  | identifier                    { result = val }
  | ParamList "," identifier      { result = val[0] << val[2] }
  ;

  Class:
    class constant Block          { result = ClassNode.new(val[1], val[2]) }
  ;

  If:
    if Expression Block           { result = IfNode.new(val[1], val[2]) }
  ;
end

---- header
  require "lexer"
  require "nodes"

---- inner
  def parse(code, show_tokens=false)
    @tokens = Lexer.new.tokenize(code) # Tokenize the code using our lexer
    puts @tokens.inspect if show_tokens
    do_parse # Kickoff the parsing process
  end

  def next_token
    @tokens.shift
  end
