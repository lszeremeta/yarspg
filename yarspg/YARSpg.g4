/*
 [The "BSD licence"]
 Copyright (c) 2018-2024, Łukasz Szeremeta (https://github.com/lszeremeta)
 All rights reserved.

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
    : STR
    ;

prop
    : key ':' value meta_prop?
    ;

edge_id
    : ALNUMPLUS
    ;

edge_label
    : STR
    ;

graph_label
    : STR
    ;

key
    : STR
    ;

value
    : primitive_value
    | complex_value
    ;

primitive_value
    : STR
    ;

complex_value
    : set_value
    | list_value
    | struct_value
    ;

set_value
    : '{' (primitive_value | complex_value) meta_prop? (',' (primitive_value | complex_value) meta_prop?)* '}'
    ;

list_value
    : '[' (primitive_value | complex_value) meta_prop? (',' (primitive_value | complex_value) meta_prop?)* ']'
    ;

struct_value
    : '{' key ':' (primitive_value | complex_value) meta_prop? (',' key ':' (primitive_value | complex_value) meta_prop?)* '}'
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
    : BOOL
    | STRING ( '(' max_length? ')' )?
    | BYTES ( '(' ( ( min_length ',' )? max_length )? ')' )?
    | INTEGER ( '(' precision? ')' )?
    | UINTEGER ( '(' precision? ')' )?
    | DECIMAL ( '(' ( precision ( ',' scale )? )? ')' )?
    | FLOAT ( '(' ( precision ( ',' scale )? )? ')' )?
    | DATETIME
    | LOCALDATETIME
    | DATE
    | TIME
    | LOCALTIME
    | DURATION
    | ALNUMPLUS
    ;

min_length
    : UNSIGNED_INT
    ;

max_length
    : UNSIGNED_INT
    ;

precision
    : UNSIGNED_INT
    ;

scale
    : UNSIGNED_INT
    ;

complex_value_schema
    : (MULTISET | SET | LIST | DLIST) '(' (primitive_value_schema | complex_value_schema) NULL? cardinality? ')' meta_prop_schema?
    | STRUCT '(' prop_schema NULL? cardinality? (',' prop_schema NULL? cardinality?)* ')' meta_prop_schema?
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
// primitive datetypes
BOOL: ( 'B' | 'b' ) ( 'O' | 'o' ) ( 'O' | 'o' ) ( 'L' | 'l' );
STRING: ( 'S' | 's' ) ( 'T' | 't' ) ( 'R' | 'r' ) ( 'I' | 'i' ) ( 'N' | 'n' ) ( 'G' | 'g' );
BYTES: ( 'B' | 'b' ) ( 'Y' | 'y' ) ( 'T' | 't' ) ( 'E' | 'e' ) ( 'S' | 's' );
INTEGER: ( 'I' | 'i' ) ( 'N' | 'n' ) ( 'T' | 't' ) ( 'E' | 'e' ) ( 'G' | 'g' ) ( 'E' | 'e' ) ( 'R' | 'r' );
UINTEGER: ( 'U' | 'u' ) ( 'I' | 'i' ) ( 'N' | 'n' ) ( 'T' | 't' ) ( 'E' | 'e' ) ( 'G' | 'g' ) ( 'E' | 'e' ) ( 'R' | 'r' );
DECIMAL: ( 'D' | 'd' ) ( 'E' | 'e' ) ( 'C' | 'c' ) ( 'I' | 'i' ) ( 'M' | 'm' ) ( 'A' | 'a' ) ( 'L' | 'l' );
FLOAT: ( 'F' | 'f' ) ( 'L' | 'l' ) ( 'O' | 'o' ) ( 'A' | 'a' ) ( 'T' | 't' );
DATETIME: ( 'D' | 'd' ) ( 'A' | 'a' ) ( 'T' | 't' ) ( 'E' | 'e' ) ( 'T' | 't' ) ( 'I' | 'i' ) ( 'M' | 'm' ) ( 'E' | 'e' );
LOCALDATETIME: ( 'L' | 'l' ) ( 'O' | 'o' ) ( 'C' | 'c' ) ( 'A' | 'a' ) ( 'L' | 'l' ) ( 'D' | 'd' ) ( 'A' | 'a' ) ( 'T' | 't' ) ( 'E' | 'e' ) ( 'T' | 't' ) ( 'I' | 'i' ) ( 'M' | 'm' ) ( 'E' | 'e' );
DATE: ( 'D' | 'd' ) ( 'A' | 'a' ) ( 'T' | 't' ) ( 'E' | 'e' );
TIME: ( 'T' | 't' ) ( 'I' | 'i' ) ( 'M' | 'm' ) ( 'E' | 'e' );
LOCALTIME: ( 'L' | 'l' ) ( 'O' | 'o' ) ( 'C' | 'c' ) ( 'A' | 'a' ) ( 'L' | 'l' ) ( 'T' | 't' ) ( 'I' | 'i' ) ( 'M' | 'm' ) ( 'E' | 'e' );
DURATION: ( 'D' | 'd' ) ( 'U' | 'u' ) ( 'R' | 'r' ) ( 'A' | 'a' ) ( 'T' | 't' ) ( 'I' | 'i' ) ( 'O' | 'o' ) ( 'N' | 'n' );

// complex datetypes
MULTISET: ( 'M' | 'm' ) ( 'U' | 'u' ) ( 'L' | 'l' ) ( 'T' | 't' ) ( 'I' | 'i' ) ( 'S' | 's' ) ( 'E' | 'e' ) ( 'T' | 't' );
SET: ( 'S' | 's' ) ( 'E' | 'e' ) ( 'T' | 't' );
LIST: ( 'L' | 'l' ) ( 'I' | 'i' ) ( 'S' | 's' ) ( 'T' | 't' );
DLIST: ( 'D' | 'd' ) ( 'L' | 'l' ) ( 'I' | 'i' ) ( 'S' | 's' ) ( 'T' | 't' );
STRUCT: ( 'S' | 's' ) ( 'T' | 't' ) ( 'R' | 'r' ) ( 'U' | 'u' ) ( 'C' | 'c' ) ( 'T' | 't' );

// keywords
DEFAULT : ( 'D' | 'd' ) ( 'E' | 'e' ) ( 'F' | 'f' ) ( 'A' | 'a' ) ( 'U' | 'u' ) ( 'L' | 'l' ) ( 'T' | 't' );
MIN: ( 'M' | 'm' ) ( 'I' | 'i' ) ( 'N' | 'n' );
MAX: ( 'M' | 'm' ) ( 'A' | 'a' ) ( 'X' | 'x' );
UNIQUE: ( 'U' | 'u' ) ( 'N' | 'n' ) ( 'I' | 'i' ) ( 'Q' | 'q' ) ( 'U' | 'u' ) ( 'E' | 'e' );
NULL: ( 'N' | 'n' ) ( 'U' | 'u' ) ( 'L' | 'l' ) ( 'L' | 'l' );
OPTIONAL: ( 'O' | 'o' ) ( 'P' | 'p' ) ( 'T' | 't' ) ( 'I' | 'i' ) ( 'O' | 'o' ) ( 'N' | 'n' ) ( 'A' | 'a' ) ( 'L' | 'l' );
// END CASE-INSENSITIVE NAMES

COMMENT
    : '#' ~[\r\n\f]* -> skip
    ;

STR
    : '"' (~ ["\\\r\n] | '\\' [tbnrf"'\\])* '"'
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
