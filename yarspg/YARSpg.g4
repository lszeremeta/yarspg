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
    : declaration+
    ;

COMMENT
    : '#' ~[\r\n\f]* -> skip
    ;

declaration
    : nodeDeclaration
    | relationship
    ;

nodeDeclaration
    : '<' node_id '>' ('{' node_label (',' node_label)* '}')? ( '[' node_prop (',' node_prop)* ']' )?
    ;

relationship
    : directed
    | undirected
    ;

directed
    : '(' node_id ')' '-' ('<' rel_id '>')? '{' rel_label '}' ('[' rel_prop (',' rel_prop)* ']')? '->' '(' node_id ')'
    ;

undirected
    : '(' node_id ')' '-' ('<' rel_id '>')? '{' rel_label '}' ('[' rel_prop (',' rel_prop)* ']')? '-' '(' node_id ')'
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

rel_id
    : STRING
    ;

rel_label
    : STRING
    ;

rel_prop
    : key ':' value
    ;

key
    : STRING
    ;

value
    : base_type_value
    | container_type_value
    ;

base_type_value
    : STRING
    | NUMBER
    | 'null'
    | BOOL
    ;

container_type_value
    : list
    ;

list
    : '[' base_type_value (',' base_type_value)* ']'
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

/* FROM TURTLE ANTLR GRAMMAR */

WS
    : [ \t\n\r]+ -> skip
    ;
