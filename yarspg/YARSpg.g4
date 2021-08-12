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
    : statement* EOF
    ;

statement
    : node
    | edge
    | doc_metadata
    | var_declaration
    | node_schema
    | edge_schema
    | var_declaration_schema
    | section
    | graph
    | graph_schema
    ;

doc_metadata
    : '-' prop_list
    ;

var
    : '$' var_name
    ;

var_declaration
    : var '=' prop (',' prop)*
    ;

var_declaration_schema
    : var '=' prop_schema (',' prop_schema)*
    ;

var_name
    : ID
    ;

graph_id
    : 'default'
    | ID
    ;

local_metadata
    : '+' prop_list
    ;

prop_list
    : '[' ( ( prop | var ) (',' ( prop | var ) )* )? ']'
    ;

meta_prop
    : '@' key ':' value
    ;

graphs_list
    : '/' graph_id (',' graph_id)* '/'
    ;

graph
    : '/' graph_id '/' ( '{' ( graph_label ( ',' graph_label )* )? '}' )? prop_list?
    ;

node
    : '(' node_id ( '{' ( node_label ( ',' node_label )* )? '}' )? prop_list? ')' graphs_list? local_metadata?
    ;

edge
    : directed
    | undirected
    ;

section
    : '%' SECTION_NAME
    ;

directed
    : '(' node_id ')' '-' '(' edge_id? ( '{' ( edge_label ( ',' edge_label )* )? '}' )? prop_list? ')' '->' '(' node_id ')' graphs_list? local_metadata?
    ;

undirected
    : '(' node_id ')' '-' '(' edge_id? ( '{' ( edge_label ( ',' edge_label )* )? '}' )? prop_list? ')' '-' '(' node_id ')' graphs_list? local_metadata?
    ;

node_id
    : ID
    ;

node_label
    : STRING
    ;

prop
    : key ':' value meta_prop*
    ;

edge_id
    : ID
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
    : set
    | list
    | struct
    ;

set
    : '{' (primitive_value | set) meta_prop* (',' (primitive_value | set) meta_prop*)* '}'
    ;

list
    : '[' (primitive_value | list) meta_prop* (',' (primitive_value | list) meta_prop*)* ']'
    ;

struct
    : '{' key ':' (primitive_value | struct) meta_prop* (',' key ':' (primitive_value | struct) meta_prop*)* '}'
    ;

node_schema
    : 'S' '(' node_id_schema ( '{' ( node_label ( ',' node_label )* )? '}' )? prop_list_schema? ')' graphs_list? local_metadata?
    ;

node_id_schema
    : ID
    ;

prop_list_schema
    : '[' ( ( prop_schema | var ) (',' ( prop_schema | var ) )* )? ']'
    ;

prop_schema
    : key ':' value_schema
    ;

meta_prop_schema
    : '@' key ':' value_schema
    ;

cardinality
    : min_cardinality max_cardinality?
    | max_cardinality
    ;

min_cardinality
    : 'MIN' card_num
    ;

max_cardinality
    : 'MAX' card_num
    ;

card_num
    : UNSIGNED_INT
    ;

value_schema
    : primitive_value_schema ('UNIQUE' | 'NULL')? 'OPTIONAL'?  meta_prop_schema*
    | complex_value_schema 'NULL'? 'OPTIONAL'? meta_prop_schema*
    ;

primitive_value_schema
    // NUMBER
    : 'Decimal'
    | 'SmallInt'
    | 'Integer'
    | 'BigInt'
    | 'Float'
    | 'Real'
    | 'Double'
    // BOOL
    | 'Bool'
    // STRING
    | 'String'
    // DATETYPE
    | 'Date'
    | 'DateTime'    
    | 'Time'
    ;

complex_value_schema
    : set_schema
    | list_schema
    | struct_schema
    ;

set_schema
    : 'Set' '(' (primitive_value_schema | set_schema) 'NULL'? cardinality? ')' meta_prop_schema*
    ;

list_schema
    : 'List' '(' (primitive_value_schema | list_schema) 'NULL'? cardinality? ')' meta_prop_schema*
    ;

struct_schema
    : 'Struct' '(' (primitive_value_schema | struct_schema) 'NULL'? cardinality? ')' meta_prop_schema*
    ;

edge_schema
    : directed_schema
    | undirected_schema
    ;

directed_schema
    : 'S' '(' node_id_schema ')' '-' ( '(' ( '{' ( edge_label ( ',' edge_label )* )? '}' )? prop_list_schema? ')' )? '->' '(' node_id_schema ')' graphs_list? local_metadata?
    ;

undirected_schema
    : 'S' '(' node_id_schema ')' '-' ( '(' ( '{' ( edge_label ( ',' edge_label )* )? '}' )? prop_list_schema? ')' )? '-' '(' node_id_schema ')' graphs_list? local_metadata?
    ;

graph_schema
    : 'S' '/' graph_id '/' prop_list_schema?
    ;

SECTION_NAME
    : 'GRAPH'
    | 'METADATA'
    | 'NODE SCHEMAS'
    | 'EDGE SCHEMAS'
    | 'NODES'
    | 'EDGES'
    ;

COMMENT
    : '#' ~[\r\n\f]* -> skip
    ;

STRING
    : '"' (~ ["\\\r\n] | '\'' | '\\"')* '"'
    ;

UNSIGNED_INT
    : [0-9]+
    ;

ID
    : [a-zA-Z_][a-zA-Z0-9_]*
    ;
    
HEX
    : [0-9] | [A-F] | [a-f]
    ;

WS
    : [ \t\n]+ -> skip
    ;
