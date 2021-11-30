/*
 [The "BSD licence"]
 Copyright (c) 2018-2021, Łukasz Szeremeta (@ University of Bialystok, https://github.com/lszeremeta)
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
    : (statement metadata?)* EOF
    ;

statement
    : node
    | edge
    | metadata
    | variable_declaration
    | node_schema
    | edge_schema
    | variable_declaration_schema
    | graph
    | graph_schema
    ;

metadata
    : '+' prop_list
    ;

variable
    : '$' variable_name
    ;

variable_declaration
    : variable '=' prop (',' prop)*
    ;

variable_declaration_schema
    : variable '=' prop_schema (',' prop_schema)*
    ;

variable_name
    : ALNUMPLUS
    ;

graph_id
    : DEFAULT
    | ALNUMPLUS
    ;

prop_list
    : '[' ( ( prop | variable ) (',' ( prop | variable ) )* )? ']'
    ;

meta_prop
    : '@' '<' ( key ':' value ( ',' key ':' value )* )? '>'
    ;

graphs_list
    : '/' graph_id (',' graph_id)* '/'
    ;

graph
    : '/' graph_id '/' ( '{' ( graph_label ( ',' graph_label )* )? '}' )? prop_list?
    ;

node
    : '(' node_id ( '{' ( node_label ( ',' node_label )* )? '}' )? prop_list? ')' graphs_list?
    ;

edge
    : directed
    | undirected
    ;

directed
    : '(' node_id ')' '-' '(' edge_id? ( '{' ( edge_label ( ',' edge_label )* )? '}' )? prop_list? ')' '->' '(' node_id ')' graphs_list?
    ;

undirected
    : '(' node_id ')' '-' '(' edge_id? ( '{' ( edge_label ( ',' edge_label )* )? '}' )? prop_list? ')' '-' '(' node_id ')' graphs_list?
    ;

node_id
    : ALNUMPLUS
    ;

node_label
    : STRING
    ;

prop
    : key ':' value meta_prop?
    ;

edge_id
    : ALNUMPLUS
    ;

edge_label
    : STRING
    ;

graph_label
    : STRING
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
    ;

complex_value
    : set_value
    | list_value
    | struct_value
    ;

set_value
    : '{' (primitive_value | set_value) meta_prop? (',' (primitive_value | set_value) meta_prop?)* '}'
    ;

list_value
    : '[' (primitive_value | list_value) meta_prop? (',' (primitive_value | list_value) meta_prop?)* ']'
    ;

struct_value
    : '{' key ':' (primitive_value | struct_value) meta_prop? (',' key ':' (primitive_value | struct_value) meta_prop?)* '}'
    ;

node_schema
    : 'S' '(' node_id_schema ( '{' ( node_label ( ',' node_label )* )? '}' )? prop_list_schema? ')' graphs_list?
    ;

node_id_schema
    : ALNUMPLUS
    ;

prop_list_schema
    : '[' ( ( prop_schema | variable ) (',' ( prop_schema | variable ) )* )? ']'
    ;

prop_schema
    : key ':' value_schema
    ;

meta_prop_schema
    : '@' '<' ( key ':' value_schema ( ',' key ':' value_schema )* )? '>'
    ;

cardinality
    : min_cardinality max_cardinality?
    | max_cardinality
    ;

min_cardinality
    : MIN card_num
    ;

max_cardinality
    : MAX card_num
    ;

card_num
    : UNSIGNED_INT
    ;

value_schema
    : primitive_value_schema (UNIQUE | NULL)? OPTIONAL?  meta_prop_schema?
    | complex_value_schema NULL? OPTIONAL? meta_prop_schema?
    ;

primitive_value_schema
    : DECIMAL
    | SMALLINT
    | INTEGER
    | UINTEGER
    | BIGINT
    | FLOAT
    | REAL
    | DOUBLE
    | BOOL
    | STRINGT
    | DATE
    | DATETIME
    | LOCALDATETIME 
    | TIME
    | LOCALTIME
    | DURATION
    | BINARY
    | ALNUMPLUS
    ;

complex_value_schema
    : multiset_schema
    | set_schema
    | list_schema
    | listd_schema
    | struct_schema
    ;

multiset_schema
    : MULTISET '(' (primitive_value_schema | multiset_schema) NULL? cardinality? ')' meta_prop_schema?
    ;

set_schema
    : SET '(' (primitive_value_schema | set_schema) NULL? cardinality? ')' meta_prop_schema?
    ;

list_schema
    : LIST '(' (primitive_value_schema | list_schema) NULL? cardinality? ')' meta_prop_schema?
    ;

listd_schema
    : LISTD '(' (primitive_value_schema | listd_schema) NULL? cardinality? ')' meta_prop_schema?
    ;

struct_schema
    : STRUCT '(' (primitive_value_schema | struct_schema) NULL? cardinality? ')' meta_prop_schema?
    ;

edge_schema
    : directed_schema
    | undirected_schema
    ;

directed_schema
    : 'S' '(' node_id_schema ')' '-' ( '(' ( '{' ( edge_label ( ',' edge_label )* )? '}' )? prop_list_schema? ')' )? '->' '(' node_id_schema ')' graphs_list?
    ;

undirected_schema
    : 'S' '(' node_id_schema ')' '-' ( '(' ( '{' ( edge_label ( ',' edge_label )* )? '}' )? prop_list_schema? ')' )? '-' '(' node_id_schema ')' graphs_list?
    ;

graph_schema
    : 'S' '/' graph_id '/' prop_list_schema?
    ;

// CASE-INSENSITIVE NAMES
DEFAULT : ( 'D' | 'd' ) ( 'E' | 'e' ) ( 'F' | 'f' ) ( 'A' | 'a' ) ( 'U' | 'u' ) ( 'L' | 'l' ) ( 'T' | 't' );
MIN: ( 'M' | 'm' ) ( 'I' | 'i' ) ( 'N' | 'n' );
MAX: ( 'M' | 'm' ) ( 'A' | 'a' ) ( 'X' | 'x' );
UNIQUE: ( 'U' | 'u' ) ( 'N' | 'n' ) ( 'I' | 'i' ) ( 'Q' | 'q' ) ( 'U' | 'u' ) ( 'E' | 'e' );
NULL: ( 'N' | 'n' ) ( 'U' | 'u' ) ( 'L' | 'l' ) ( 'L' | 'l' );
OPTIONAL: ( 'O' | 'o' ) ( 'P' | 'p' ) ( 'T' | 't' ) ( 'I' | 'i' ) ( 'O' | 'o' ) ( 'N' | 'n' ) ( 'A' | 'a' ) ( 'L' | 'l' );

// primitive datetypes
DECIMAL: ( 'D' | 'd' ) ( 'E' | 'e' ) ( 'C' | 'c' ) ( 'I' | 'i' ) ( 'M' | 'm' ) ( 'A' | 'a' ) ( 'L' | 'l' );
SMALLINT: ( 'S' | 's' ) ( 'M' | 'm' ) ( 'A' | 'a' ) ( 'L' | 'l' ) ( 'L' | 'l' ) ( 'I' | 'i' ) ( 'N' | 'n' ) ( 'T' | 't' );
INTEGER: ( 'I' | 'i' ) ( 'N' | 'n' ) ( 'T' | 't' ) ( 'E' | 'e' ) ( 'G' | 'g' ) ( 'E' | 'e' ) ( 'R' | 'r' );
UINTEGER: ( 'U' | 'u' ) ( 'I' | 'i' ) ( 'N' | 'n' ) ( 'T' | 't' ) ( 'E' | 'e' ) ( 'G' | 'g' ) ( 'E' | 'e' ) ( 'R' | 'r' );
BIGINT: ( 'B' | 'b' ) ( 'I' | 'i' ) ( 'G' | 'g' ) ( 'I' | 'i' ) ( 'N' | 'n' ) ( 'T' | 't' );
FLOAT: ( 'F' | 'f' ) ( 'L' | 'l' ) ( 'O' | 'o' ) ( 'A' | 'a' ) ( 'T' | 't' );
REAL: ( 'R' | 'r' ) ( 'E' | 'e' ) ( 'A' | 'a' ) ( 'L' | 'l' );
DOUBLE: ( 'D' | 'd' ) ( 'O' | 'o' ) ( 'U' | 'u' ) ( 'B' | 'b' ) ( 'L' | 'l' ) ( 'E' | 'e' );
BOOL: ( 'B' | 'b' ) ( 'O' | 'o' ) ( 'O' | 'o' ) ( 'L' | 'l' );
STRINGT: ( 'S' | 's' ) ( 'T' | 't' ) ( 'R' | 'r' ) ( 'I' | 'i' ) ( 'N' | 'n' ) ( 'G' | 'g' );
DATE: ( 'D' | 'd' ) ( 'A' | 'a' ) ( 'T' | 't' ) ( 'E' | 'e' );
DATETIME: ( 'D' | 'd' ) ( 'A' | 'a' ) ( 'T' | 't' ) ( 'E' | 'e' ) ( 'T' | 't' ) ( 'I' | 'i' ) ( 'M' | 'm' ) ( 'E' | 'e' );
LOCALDATETIME: ( 'L' | 'l' ) ( 'O' | 'o' ) ( 'C' | 'c' ) ( 'A' | 'a' ) ( 'L' | 'l' ) ( 'D' | 'd' ) ( 'A' | 'a' ) ( 'T' | 't' ) ( 'E' | 'e' ) ( 'T' | 't' ) ( 'I' | 'i' ) ( 'M' | 'm' ) ( 'E' | 'e' );
TIME: ( 'T' | 't' ) ( 'I' | 'i' ) ( 'M' | 'm' ) ( 'E' | 'e' );
LOCALTIME: ( 'L' | 'l' ) ( 'O' | 'o' ) ( 'C' | 'c' ) ( 'A' | 'a' ) ( 'L' | 'l' ) ( 'T' | 't' ) ( 'I' | 'i' ) ( 'M' | 'm' ) ( 'E' | 'e' );
DURATION: ( 'D' | 'd' ) ( 'U' | 'u' ) ( 'R' | 'r' ) ( 'A' | 'a' ) ( 'T' | 't' ) ( 'I' | 'i' ) ( 'O' | 'o' ) ( 'N' | 'n' );
BINARY: ( 'B' | 'b' ) ( 'I' | 'i' ) ( 'N' | 'n' ) ( 'A' | 'a' ) ( 'R' | 'r' ) ( 'Y' | 'y' );

// complex datetypes
MULTISET: ( 'M' | 'm' ) ( 'U' | 'u' ) ( 'L' | 'l' ) ( 'T' | 't' ) ( 'I' | 'i' ) ( 'S' | 's' ) ( 'E' | 'e' ) ( 'T' | 't' );
SET: ( 'S' | 's' ) ( 'E' | 'e' ) ( 'T' | 't' );
LIST: ( 'L' | 'l' ) ( 'I' | 'i' ) ( 'S' | 's' ) ( 'T' | 't' );
LISTD: ( 'L' | 'l' ) ( 'I' | 'i' ) ( 'S' | 's' ) ( 'T' | 't' ) ( 'D' | 'd' );
STRUCT: ( 'S' | 's' ) ( 'T' | 't' ) ( 'R' | 'r' ) ( 'U' | 'u' ) ( 'C' | 'c' ) ( 'T' | 't' );
// END CASE-INSENSITIVE NAMES

COMMENT
    : '#' ~[\r\n\f]* -> skip
    ;

STRING
    : '"' (~ ["\\\r\n] | '\'' | '\\"')* '"'
    ;

UNSIGNED_INT
    : [0-9]+
    ;

ALNUMPLUS
    : [a-zA-Z_][a-zA-Z0-9_]*
    ;

WS
    : [ \t\n]+ -> skip
    ;
