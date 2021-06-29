//
//  BarcodeDataMatcher+String.swift
//  BarcodeDataMatcher
//
//  Created by Jakub Dolejs on 29/06/2021.
//

import Foundation

public extension String {
    
    func match(_ other: String) throws -> Float {
        let this = self.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: nil)
        let otherPrepared = self.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: nil)
        return try DamerauLevenshtein.distance(between: this, and: otherPrepared).similarity
    }
}
