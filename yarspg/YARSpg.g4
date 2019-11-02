/*
 [The "BSD licence"]
 Copyright (c) 2018-2019, Łukasz Szeremeta (@ University of Bialystok, http://www.uwb.edu.pl/)
 Copyright (c) 2018, Dominik Tomaszuk (@ University of Bialystok, http://www.uwb.edu.pl/)
 Copyright (c) 2018, Karol Litman (@ University of Bialystok, http://www.uwb.edu.pl/)
 All rights reserved.

 Based on YARS grammar
 (https://github.com/lszeremeta/antlr-yars/blob/master/yars/YARS.g4)
 distributed under BSD licence.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 1. Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.
 3. The name of the author may not be used to endorse or promote products
    derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
*/

grammar YARSpg;

yarspg
    : statement+ EOF
    ;

COMMENT
    : '#' ~[\r\n\f]* -> skip
    ;

statement
    : node
    | edge
    | prefixDirective
    | metadata
    | node_schema
    ;

prefixDirective
    : pname IRI
    ;

pname
    : ':' ALNUM_PLUS ':'
    ;

pn_local
    : ALNUM_PLUS
    ;

metadata
    : '@' pn_local pname (STRING | IRI)
    | '@' IRI ':' (STRING | IRI)
    ;

annotation
    : named_graph_annotation
    | string_annotation
    | rdf_annotation
    ;

named_graph_annotation
    : '"graph"' ':' STRING
    ;

string_annotation
    : STRING ':' STRING
    ;

rdf_annotation
    : pn_local pname (STRING | IRI)
    | IRI ':' (STRING | IRI)
    ;

node
    : '<' node_id '>' ('{' node_label (',' node_label)* '}')? ( '[' node_prop (',' node_prop)* ']' )? ( '?' annotation (',' annotation)* )?
    ;

edge
    : directed
    | undirected
    ;

directed
    : '(' node_id ')' '-' ('<' edge_id '>')? '{' edge_label '}' ('[' edge_prop (',' edge_prop)* ']')? '->' '(' node_id ')' ( '?' annotation (',' annotation)* )?
    ;

undirected
    : '(' node_id ')' '-' ('<' edge_id '>')? '{' edge_label '}' ('[' edge_prop (',' edge_prop)* ']')? '-' '(' node_id ')' ( '?' annotation (',' annotation)* )?
    ;

node_id
    : STRING
    ;

node_label
    : STRING
    ;

node_prop
    : key ':' value
    ;

edge_id
    : STRING
    ;

edge_label
    : STRING
    ;

edge_prop
    : key ':' value
    ;

key
    : STRING
    ;

value
    : primitive_value
    | complex_value
    ;

primitive_value
    : STRING
    | NUMBER
    | 'null'
    | BOOL
    ;

complex_value
    : multiset
    | list
    | dict
    ;

multiset
    : '{' (primitive_value | multiset) (',' (primitive_value | multiset))* '}'
    ;

list
    : '[' (primitive_value | list) (',' (primitive_value | list))* ']'
    ;

dict
    : '{' key ':' (primitive_value | dict) (',' key ':' (primitive_value | dict))* '}'
    ;

STRING
    : STRING_LITERAL_QUOTE
    ;

NUMBER
    : [0-9]+'.'?[0-9]*
    ;

BOOL
    : 'true'
    | 'false'
    ;

/* FROM TURTLE ANTLR GRAMMAR */

STRING_LITERAL_QUOTE
    : '"' (~ ["\\\r\n] | '\'' | '\\"')* '"'
    ;

ALNUM_PLUS
    : PN_CHARS_BASE ((PN_CHARS | '.')* PN_CHARS)?
    ;
IRI
    : '<' (PN_CHARS | '.' | ':' | '/' | '\\' | '#' | '@' | '%' | '&' | UCHAR)* '>'
    ;
PN_CHARS
    : PN_CHARS_U | '-' | [0-9] | '\u00B7' | [\u0300-\u036F] | [\u203F-\u2040]
    ;
PN_CHARS_U
    : PN_CHARS_BASE | '_'
    ;
UCHAR
    : '\\u' HEX HEX HEX HEX | '\\U' HEX HEX HEX HEX HEX HEX HEX HEX
    ;
PN_CHARS_BASE
    : 'A' .. 'Z' | 'a' .. 'z' | '0' .. '9' | '\u00C0' .. '\u00D6' | '\u00D8' .. '\u00F6' | '\u00F8' .. '\u02FF' | '\u0370' .. '\u037D' | '\u037F' .. '\u1FFF' | '\u200C' .. '\u200D' | '\u2070' .. '\u218F' | '\u2C00' .. '\u2FEF' | '\u3001' .. '\uD7FF' | '\uF900' .. '\uFDCF' | '\uFDF0' .. '\uFFFD'
    ;
HEX
    : [0-9] | [A-F] | [a-f]
    ;

/* FROM TURTLE ANTLR GRAMMAR */

/* YARS-PG SCHEMA */
node_schema
    : 'S' ('{' node_label (',' node_label)* '}')? ( '[' node_prop_schema (',' node_prop_schema)* ']' )? ( '?' annotation (',' annotation)* )?
    ;

node_prop_schema
    : key ':' value_schema
    ;

value_schema
    : primitive_value_schema
    | complex_value_schema
    ;

primitive_value_schema
    : 'String'
    | 'Number'
    | 'Null'
    | 'Bool'
    ;

complex_value_schema
    : multiset_schema
    | list_schema
    | dict_schema
    ;

multiset_schema
    : bag_schema
    | set_schema
    ;

bag_schema
    : 'Bag' '(' (primitive_value_schema | bag_schema) ')'
    ;

set_schema
    : 'Set' '(' (primitive_value_schema | set_schema) ')'
    ;

list_schema
    : 'List' '(' (primitive_value_schema | list_schema) ')'
    ;

dict_schema
    : 'Dict' '(' (primitive_value_schema | dict_schema) ')'
    ;

/* YARS-PG SCHEMA */

WS
    : [ \t\n\r]+ -> skip
    ;
