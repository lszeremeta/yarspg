# YARS-PG grammar

[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/lszeremeta/yarspg/pre-release.yml?label=Test%20and%20pre-release)](https://github.com/lszeremeta/yarspg/actions/workflows/pre-release.yml) [![GitHub Release](https://img.shields.io/github/v/release/lszeremeta/yarspg)](https://github.com/lszeremeta/yarspg/releases/latest) [![DOI](https://zenodo.org/badge/161351716.svg)](https://zenodo.org/badge/latestdoi/161351716) 

The YARS-PG serialization is designed for property graphs (but not only):
* YARS-PG supports all the features allowed by the current database systems based on the property graph data model,
* YARS-PG provides a simple syntax with a reduced number of extra characters,
* YARS-PG is inspired by the syntax used by popular graph query languages (e.g. Cypher and GQL) to encode the structure of a property graph (i.e. nodes, edges, and properties).

The YARS-PG grammar is written in [ANTLR4](https://github.com/antlr/antlr4). If you prefer [Extended Backus-Naur Form (EBNF)](https://www.w3.org/TR/REC-xml/#sec-notation) notation, you can also see [YARS-PG grammar in EBNF](https://github.com/lszeremeta/antlr-yarspg/blob/main/other-notations/YARSpg.ebnf). You may also see YARS-PG [examples](https://github.com/lszeremeta/yarspg/tree/main/yarspg/examples).

## Parsers

The YARS-PG parsers are available in the [parsers](https://github.com/lszeremeta/yarspg/blob/main/parsers). Currently, there are parsers for the following languages:
* [Java](https://github.com/lszeremeta/yarspg/blob/main/parsers/java)
* [Python](https://github.com/lszeremeta/yarspg/blob/main/parsers/python)

If you want to help build YARS-PG parsers for other languages, please follow the [ANTLR4 documentation](https://github.com/antlr/antlr4/tree/dev/doc) and create a pull request.

See the ``README.md`` file in each parser directory for more details. Ready-to-use parsers are also available in the Assets section in [Releases](https://github.com/lszeremeta/yarspg/releases).

## Testing grammar

Run tests on files in ``yarspg/examples``:

```shell
mvn clean test
```

This project is based on the [ANTLR grammars-v4 project](https://github.com/antlr/grammars-v4).

## Contribution

Would you like to improve this project? Great! We are waiting for your help and suggestions. If you are new to open source contributions, read [How to Contribute to Open Source](https://opensource.guide/how-to-contribute/).

## License

Distributed under [BSD 3-Clause License](https://github.com/lszeremeta/yarspg/blob/main/LICENSE).
