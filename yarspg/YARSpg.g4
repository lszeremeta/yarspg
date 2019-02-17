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
    : (statement NL+) *
    ;

statement
    : declaration
    ;

declaration
    : nodeDeclaration
    | relationship
    ;

nodeDeclaration
    : ido ('[' node_label (':' node_label)* ']')? '{' prop (',' prop)* '}'
    ;

relationship
    : directed
    | undirected
    ;

directed
    : '(' ido ')' '-' '[' relationship_label ('{' prop (',' prop)* '}')* ']' '->' '(' ido ')'
    ;

undirected
    : '(' ido ')' '-' '[' relationship_label ('{' prop (',' prop)* '}')* ']' '-' '(' ido ')'
    ;

relationship_label
    : ALNUM_PLUS
    ;
    
ido
    : ALNUM_PLUS
    ;

node_label
    : ALNUM_PLUS
    ;

prop
    : key ':' value
    ;

key
    : ALNUM_PLUS
    ;

value
    : single_key_value
    | multiple_key_values
    ;

single_key_value
    : STRING
    | NUMBER
    | 'null'
    | TRUE_FALSE
    ;

multiple_key_values
    : '[' single_key_value (',' single_key_value)* ']'
    ;

STRING
    : STRING_LITERAL_QUOTE
    ;

NUMBER
    : [0-9]+'.'?[0-9]*
    ;

TRUE_FALSE
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

SP
    : (' ' | [\t] )+ -> skip
    ;

NL
    : [\r\n]
    ;
