# YARS-PG grammar

[![Build Status](https://travis-ci.com/lszeremeta/yarspg.svg?branch=master)](https://travis-ci.com/lszeremeta/yarspg)
[![DOI](https://zenodo.org/badge/161351716.svg)](https://zenodo.org/badge/latestdoi/161351716)

The YARS-PG serialization is a special version of [YARS](https://github.com/lszeremeta/yars) for property graphs. This serialization is specially designed for property graphs:
* YARS-PG supports all the features allowed by the current database systems based on the property graph data model,
* YARS-PG provides a simple syntax with a reduced number of extra characters,
* YARS-PG is inspired on the syntax used by popular graph query languages (e.g. Cypher and GQL) to encode the structure of a property graph (i.e. nodes, edges and properties).

The YARS-PG grammar is written in [ANTLR4](https://github.com/antlr/antlr4). If you prefer [Extended Backus-Naur Form (EBNF)](https://www.w3.org/TR/REC-xml/#sec-notation) notation, you can also see preview version of [YARS-PG grammar in EBNF](https://github.com/lszeremeta/antlr-yarspg/blob/master/other-notations/YARSpg.ebnf). See [YARS-PG specification](https://lszeremeta.github.io/yarspg/index.html) or detailed [Serialization for Property Graphs presentation](https://www.researchgate.net/publication/340208659_Serialization_for_Property_Graphs) for more details.

This project based on [ANTLR grammars-v4 project](https://github.com/antlr/grammars-v4).

## Testing grammar

Run tests on files in ``yarspg/examples``:

```shell
mvn clean test
```

## Contribution

Would you like to improve this project? Great! We are waiting for your help and suggestions. If you are new in open source contributions, read [How to Contribute to Open Source](https://opensource.guide/how-to-contribute/).

## License

Distributed under [BSD 3-Clause License](https://github.com/lszeremeta/yarspg/blob/master/LICENSE).
