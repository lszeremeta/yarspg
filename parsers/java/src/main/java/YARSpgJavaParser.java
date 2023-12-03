import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;

public class YARSpgJavaParser {
    private static boolean errorOccurred = false;

    public static void main(String[] args) throws Exception {
        boolean printTree = false;
        String inputFile = null;

        for (String arg : args) {
            if ("-t".equals(arg) || "--tree".equals(arg)) {
                printTree = true;
            } else if (inputFile == null) {
                inputFile = arg;
            } else {
                printUsageAndExit();
            }
        }

        if (inputFile == null) {
            printUsageAndExit();
        }

        CharStream input = CharStreams.fromFileName(inputFile);

        YARSpgLexer lexer = new YARSpgLexer(input);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        YARSpgParser parser = new YARSpgParser(tokens);

        parser.removeErrorListeners();
        parser.addErrorListener(new BaseErrorListener() {
            @Override
            public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol, int line, int charPositionInLine, String msg, RecognitionException e) {
                System.err.println("line " + line + ":" + charPositionInLine + " " + msg);
                errorOccurred = true;
            }
        });

        ParseTree tree = parser.yarspg();

        if (printTree) {
            System.out.println(tree.toStringTree(parser));
        }

        if (errorOccurred) {
            System.exit(1);
        }
    }

    private static void printUsageAndExit() {
        System.err.println("Usage: java -jar yarspg-java-parser.jar <path-to-yarspg-file> [-t|--tree]");
        System.err.println("where <path-to-yarspg-file> is the path to the .yarspg file you want to parse.");
        System.err.println("The optional -t or --tree argument prints the parse tree.");
        System.exit(1);
    }
}
