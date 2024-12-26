//
//  JavaScriptConfiguration.swift
//
//
//  Created by Robert Matwiejczyk on 26/12/2024.
//

import Foundation
import RegexBuilder

private let javascriptReservedIdentifiers = [
    // Keywords
    "break", "case", "catch", "class", "const", "continue", "debugger", "default", "delete",
    "do", "else", "enum", "export", "extends", "false", "finally", "for", "function", "if",
    "implements", "import", "in", "instanceof", "interface", "let", "new", "null", "package",
    "private", "protected", "public", "return", "super", "switch", "static", "this", "throw",
    "try", "true", "typeof", "var", "void", "while", "with", "yield",
    
    // ES6+ Keywords
    "await", "async", "of", "as",
    
    // Future reserved words
    "abstract", "arguments", "boolean", "byte", "char", "double", "final", "float", "goto",
    "int", "long", "native", "short", "synchronized", "throws", "transient", "volatile"
]

private let javascriptReservedOperators = [
    // Basic operators
    "+", "-", "*", "/", "%", "=", "!", "&", "|", "^", "~", "?", ":",
    // Compound operators
    "+=", "-=", "*=", "/=", "%=", "&&", "||", "??",
    // Comparison operators
    "==", "===", "!=", "!==", "<", ">", "<=", ">=",
    // Other symbols
    ".", ",", ";", "(", ")", "[", "]", "{", "}", "=>", "...", "`"
]

extension LanguageConfiguration {
    
    /// Language configuration for JavaScript
    ///
    public static func javascript(_ languageService: LanguageService? = nil) -> LanguageConfiguration {
        let numberRegex: Regex<Substring> = Regex {
            optNegation
            ChoiceOf {
                // Binary (0b)
                Regex { /0[bB]/; binaryLit }
                // Octal (0o)
                Regex { /0[oO]/; octalLit }
                // Hexadecimal (0x)
                Regex { /0[xX]/; hexalLit }
                // Scientific notation
                Regex { decimalLit; "."; decimalLit; Optionally { exponentLit } }
                // Integer with optional scientific notation
                Regex { decimalLit; Optionally { exponentLit } }
                // BigInt
                Regex { decimalLit; "n" }
            }
        }
        
        let identifierRegex = Regex {
            ChoiceOf {
                // Standard identifier
                Regex {
                    identifierHeadCharacters
                    ZeroOrMore {
                        identifierCharacters
                    }
                }
                // Dollar sign identifiers
                Regex { "$";
                    ZeroOrMore {
                        identifierCharacters
                    }
                }
                // Underscore identifiers
                Regex { "_";
                    ZeroOrMore {
                        identifierCharacters
                    }
                }
            }
        }
        
        let operatorRegex = Regex {
            ChoiceOf {
                // Standard operators
                Regex {
                    operatorHeadCharacters
                    ZeroOrMore {
                        operatorCharacters
                    }
                }
                // Arrow function
                "=>"
                // Spread/rest operator
                "..."
                // Optional chaining
                "?."
                // Nullish coalescing
                "??"
            }
        }
        
        return LanguageConfiguration(
            name: "JavaScript",
            supportsSquareBrackets: true,
            supportsCurlyBrackets: true,
            // Support both single and double quoted strings, plus template literals
            stringRegex: /(?:\"(?:\\\"|[^\"])*+\")|(?:\'(?:\\\'|[^\'])*+\')|(?:`(?:\\`|[^`])*+`)/,
            // JavaScript doesn't have character literals
            characterRegex: nil,
            numberRegex: numberRegex,
            singleLineComment: "//",
            nestedComment: (open: "/*", close: "*/"),
            identifierRegex: identifierRegex,
            operatorRegex: operatorRegex,
            reservedIdentifiers: javascriptReservedIdentifiers,
            reservedOperators: javascriptReservedOperators,
            languageService: languageService
        )
    }
}
