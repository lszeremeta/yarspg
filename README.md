# YARS-PG grammar

[![Test and pre-release](https://github.com/lszeremeta/yarspg/actions/workflows/pre-release.yml/badge.svg)](https://github.com/lszeremeta/yarspg/actions/workflows/pre-release.yml)
[![DOI](https://zenodo.org/badge/161351716.svg)](https://zenodo.org/badge/latestdoi/161351716)

The YARS-PG serialization is a special version of [YARS](https://github.com/lszeremeta/yars) for property graphs. This serialization is specially designed for property graphs:
* YARS-PG supports all the features allowed by the current database systems based on the property graph data model,
* YARS-PG provides a simple syntax with a reduced number of extra characters,
* YARS-PG is inspired by the syntax used by popular graph query languages (e.g. Cypher and GQL) to encode the structure of a property graph (i.e. nodes, edges, and properties).

The YARS-PG grammar is written in [ANTLR4](https://github.com/antlr/antlr4). If you prefer [Extended Backus-Naur Form (EBNF)](https://www.w3.org/TR/REC-xml/#sec-notation) notation, you can also see a preview version of [YARS-PG grammar in EBNF](https://github.com/lszeremeta/antlr-yarspg/blob/main/other-notations/YARSpg.ebnf). See [YARS-PG specification](https://lszeremeta.github.io/yarspg/index.html) or detailed [Serialization for Property Graphs presentation](https://www.researchgate.net/publication/340208659_Serialization_for_Property_Graphs) for more details.

This project is based on the [ANTLR grammars-v4 project](https://github.com/antlr/grammars-v4).

## Parsers

The YARS-PG parsers are available in the [parsers](https://github.com/lszeremeta/yarspg/blob/main/parsers). Currently, there are parsers for the following languages:
* [Java](https://github.com/lszeremeta/yarspg/blob/main/parsers/java)
* [Python](https://github.com/lszeremeta/yarspg/blob/main/parsers/python)

If you want to help build YARS-PG parsers for other languages, please follow the [ANTLR4 documentation](https://github.com/antlr/antlr4/tree/dev/doc) and create a pull request.

See the ``README.md`` file in each parser directory for more details. Ready to use parsers are also available in the [Releases](https://github.com/lszeremeta/yarspg/releases)'s assets.

## Testing grammar

Run tests on files in ``yarspg/examples``:

```shell
mvn clean test
```

## Contribution

Would you like to improve this project? Great! We are waiting for your help and suggestions. If you are new to open source contributions, read [How to Contribute to Open Source](https://opensource.guide/how-to-contribute/).

## License

Distributed under [BSD 3-Clause License](https://github.com/lszeremeta/yarspg/blob/main/LICENSE).
