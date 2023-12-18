# YARS-PG Java parser

```shell
Usage: java -jar yarspg-java-parser.jar <path-to-yarspg-file> [-t|--tree]
where <path-to-yarspg-file> is the path to the .yarspg file you want to parse.
The optional -t or --tree argument prints the parse tree.
```

## Usage

1. Build the project:

```shell
mvn clean package
```

2. Run the parser:

```shell
java -jar target/yarspg-java-parser-1.0-SNAPSHOT.jar path/to/file.yarspg
```

Optionally, you can also print a parse tree:

```shell
java -jar target/yarspg-java-parser-1.0-SNAPSHOT.jar path/to/file.yarspg --tree
```

```shell
java -jar target/yarspg-java-parser-1.0-SNAPSHOT.jar path/to/file.yarspg -t
```
