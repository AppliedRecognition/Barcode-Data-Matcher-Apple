//
//  BarcodeDataMatcher+String.swift
//  BarcodeDataMatcher
//
//  Created by Jakub Dolejs on 29/06/2021.
//

import Foundation

/// String matching extension
/// - Since: 1.0.0
public extension String {
    
    /// Match this string to another string using [Damerau-Levenshtein distance](https://en.wikipedia.org/wiki/Damerau–Levenshtein_distance) and return a score
    /// - Parameter other: String to match to
    /// - Parameter options: Matching options, default is case and diacritic insensitive
    /// - Throws: Error if the matching fails
    /// - Returns: Match score (0 = this string has no similarities with the other string, 1 = this string is similar as the other string)
    /// - Since: 1.0.0
    func match(_ other: String, options: String.CompareOptions = [.diacriticInsensitive, .caseInsensitive]) throws -> Float {
        let this = self.folding(options: options, locale: nil)
        let otherPrepared = self.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: nil)
        return try DamerauLevenshtein.distance(between: this, and: otherPrepared).similarity
    }
}
