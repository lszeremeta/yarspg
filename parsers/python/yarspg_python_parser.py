import sys

from YARSpgLexer import YARSpgLexer
from YARSpgParser import YARSpgParser
from antlr4 import *
from antlr4.error.ErrorListener import ErrorListener


def print_usage_and_exit():
    print("Usage: python yarspg_python_parser.py <path-to-yarspg-file> [-t|--tree]", file=sys.stderr)
    print("where <path-to-yarspg-file> is the path to the .yarspg file you want to parse.", file=sys.stderr)
    print("The optional -t or --tree argument prints the parse tree.", file=sys.stderr)
    sys.exit(1)


class CustomErrorListener(ErrorListener):
    def __init__(self):
        super(CustomErrorListener, self).__init__()
        self.errorOccurred = False

    def syntaxError(self, recognizer, offendingSymbol, line, charPositionInLine, msg, e):
        print(f"line {line}:{charPositionInLine} {msg}", file=sys.stderr)
        self.errorOccurred = True


def main(argv):
    if len(argv) < 2:
        print_usage_and_exit()

    print_tree = False
    input_file = None
    error_listener = CustomErrorListener()

    for arg in argv[1:]:
        if arg in ("-t", "--tree"):
            print_tree = True
        elif input_file is None:
            input_file = arg
        else:
            print_usage_and_exit()

    if input_file is None:
        print_usage_and_exit()

    input_stream = FileStream(input_file, encoding='utf-8')
    lexer = YARSpgLexer(input_stream)
    stream = CommonTokenStream(lexer)
    parser = YARSpgParser(stream)

    parser.removeErrorListeners()
    parser.addErrorListener(error_listener)
    tree = parser.yarspg()

    if print_tree:
        print(tree.toStringTree(recog=parser))

    if error_listener.errorOccurred:
        sys.exit(1)


if __name__ == '__main__':
    main(sys.argv)
