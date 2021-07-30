//
//  BarcodeMatching.swift
//  BarcodeDataMatcher
//
//  Created by Jakub Dolejs on 29/06/2021.
//

import Foundation

/// Barcode matching protocol
/// - Since: 1.0.0
public protocol BarcodeMatching {
    
    /// Match barcode data and return score
    /// - Parameter barcodeData: Barcode data to match against
    /// - Returns: Score from 0 (no match) to 1 (full match)
    /// - Since: 1.0.0
    func match(_ barcodeData: Data) throws -> Float
}
