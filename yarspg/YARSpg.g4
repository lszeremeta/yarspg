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
    : statement* EOF
    ;

statement
    : node
    | edge
    | prefix_directive
    | metadata
    | var_declaration
    | node_schema
    | edge_schema
    | var_declaration_schema
    | section
    | graph
    ;

prefix_directive
    : pname IRI
    ;

pname
    : ':' ALNUM_PLUS ':'
    ;

pn_local
    : ALNUM_PLUS
    ;

metadata
    : '-' ((pn_local pname) | (IRI ':')) (STRING | IRI)
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
    : ALNUM_PLUS
    ;

graph_name
    : STRING
    ;

annotation
    : string_annotation
    | rdf_annotation
    ;

string_annotation
    : key ':' STRING
    ;

rdf_annotation
    : ((pn_local pname) | (IRI ':')) (STRING | IRI)
    ;

annotations_list
    : '+' '[' annotation (',' annotation)* ']'
    ;

props_list
    : '[' ( ( prop | var ) (',' ( prop | var ) )* )? ']'
    ;

meta_prop
    : '@' key ':' value
    ;

graphs_list
    : '/' graph_name (',' graph_name)* '/'
    ;

graph
    : '/' graph_name '/' ( '{' ( graph_label ( ',' graph_label )* )? '}' )? props_list?
    ;

node
    : '(' node_id ( '{' ( node_label ( ',' node_label )* )? '}' )? props_list? ')' graphs_list? annotations_list?
    ;

edge
    : directed
    | undirected
    ;

section
    : '%' SECTION_NAME
    ;

directed
    : '(' node_id ')' '-' '(' edge_id? ( '{' ( edge_label ( ',' edge_label )* )? '}' )? props_list? ')' '->' '(' node_id ')' graphs_list? annotations_list?
    ;

undirected
    : '(' node_id ')' '-' '(' edge_id? ( '{' ( edge_label ( ',' edge_label )* )? '}' )? props_list? ')' '-' '(' node_id ')' graphs_list? annotations_list?
    ;

node_id
    : STRING
    ;

node_label
    : STRING
    ;

prop
    : key ':' value meta_prop*
    ;

edge_id
    : STRING
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
    | DATETYPE
    | NUMBER
    | BOOL
    | 'null'
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
    : 'S' '(' ( '{' ( node_label ( ',' node_label )* )? '}' )? prop_list_schema? ')' graphs_list? annotations_list?
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

value_schema
    : primitive_value_schema ('ID' | 'NULL')? meta_prop_schema*
    | complex_value_schema 'NULL'?
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
    : 'Set' '(' (primitive_value_schema 'NULL'? | set_schema) ')' meta_prop_schema*
    ;

list_schema
    : 'List' '(' (primitive_value_schema 'NULL'? | list_schema) ')' meta_prop_schema*
    ;

struct_schema
    : 'Struct' '(' (primitive_value_schema 'NULL'? | struct_schema) ')' meta_prop_schema*
    ;

edge_schema
    : directed_schema
    | undirected_schema
    ;

directed_schema
    : 'S' '(' node_label ')' '-' '(' ( '{' ( edge_label ( ',' edge_label )* )? '}' )? prop_list_schema? ')' '->' '(' node_label ')'
    ;

undirected_schema
    : 'S' '(' node_label ')' '-' '(' ( '{' ( edge_label ( ',' edge_label )* )? '}' )? prop_list_schema? ')' '-' '(' node_label ')'
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
    : STRING_LITERAL_QUOTE
    ;

NUMBER
    : INTEGER
    | DECIMAL
    | DOUBLE
    ;

INTEGER
   : SIGN? [0-9]+
   ;

DECIMAL
   : SIGN? [0-9]* '.' [0-9]+
   ;

DOUBLE
   : SIGN? ([0-9]+ '.' [0-9]* EXPONENT | '.' [0-9]+ EXPONENT | [0-9]+ EXPONENT)
   ;

EXPONENT
   : [eE] SIGN? [0-9]+
   ;

BOOL
    : 'true'
    | 'false'
    ;

DATETYPE
    : DATETIME | DATE | TIME
    ;

DATE
    : [0-9][0-9][0-9][0-9] '-' [0-9][0-9] '-' [0-9][0-9]
    ;

TIME
    : [0-9][0-9] ':' [0-9][0-9] ':' [0-9][0-9] TIMEZONE?
    ;

TIMEZONE
    : SIGN? [0-9][0-9] ':' [0-9][0-9]
    ;

DATETIME
    : DATE 'T' TIME
    ;

SIGN
    : '+'
    | '-'
    ;

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

WS
    : [ \t\n]+ -> skip
    ;
