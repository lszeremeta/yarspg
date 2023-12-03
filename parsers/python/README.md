# YARS-PG Python parser

```shell
Usage: python yarspg_python_parser.py <path-to-yarspg-file> [-t|--tree]
where <path-to-yarspg-file> is the path to the .yarspg file you want to parse.
The optional -t or --tree argument prints the parse tree.
```

## Usage

You can skip steps 2 and 3 if you downloaded the YARS-PG Python parser from the [releases](https://github.com/lszeremeta/yarspg/releases).

1. Prepare the environment:

Install `antlr4-python3-runtime`:

```shell
pip install -r requirements.txt
```

2. Download the ANTRL4 Java binaries:

```shell
curl -O https://www.antlr.org/download/antlr-4.13.1-complete.jar
```

3. Generate the Python target:
    
```shell
java -jar antlr-4.13.1-complete.jar -Dlanguage=Python3 -o /path/to/this/directory /path/to/grammar/YARSpg.g4
```

4. Run the parser:

```shell
python yarspg_python_parser.py path/to/file.yarspg
```

Optionally, you can also print a parse tree:

```shell
python yarspg_python_parser.py path/to/file.yarspg --tree
```

```shell
python yarspg_python_parser.py path/to/file.yarspg -t
```

## Notes

Python parser is much slower than the Java one because of the ANTLR's Python implementation. It is not recommended to use a Python parser for large files.

You may consider using the Java parser instead or try to build a C++ parser target and use it with Python (example: [amykyta3/speedy-antlr-tool](https://github.com/amykyta3/speedy-antlr-tool)).

## Contribution

Would you like to improve this project? Great! We are waiting for your help and suggestions. If you are new to open source contributions, read [How to Contribute to Open Source](https://opensource.guide/how-to-contribute/).

## License

Distributed under [BSD 3-Clause License](https://github.com/lszeremeta/yarspg/blob/main/LICENSE).
