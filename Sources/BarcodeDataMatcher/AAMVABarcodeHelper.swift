//
//  AAMVABarcodeHelper.swift
//  BarcodeDataMatcher
//
//  Created by Jakub Dolejs on 29/06/2021.
//

import Foundation
import AAMVABarcodeParser

/// Helper class to extract useful parameters from AAMVA-compatible barcodes
/// - Since: 1.0.0
public class AAMVABarcodeHelper {
    
    private init() {
    }
    
    /// Default singleton instance
    /// - Since: 1.0.0
    public static let `default`: AAMVABarcodeHelper = AAMVABarcodeHelper()
    
    /// Get the [AAMVA specification](https://www.aamva.org/DL-ID-Card-Design-Standard/) version that the barcode data follows
    /// - Parameter data: Barcode data
    /// - Returns: Version of the AAMVA spec followed in the barcode or `nil` if the barcode is not AAMVA-spec compliant
    /// - Since: 1.0.0
    public func aamvaSpecVersion(from data: Data) -> Int? {
        guard data[0] == 0x40 else {
            return nil
        }
        guard let str = String(data: data[15..<17], encoding: .utf8) else {
            return nil
        }
        return Int(str)
    }
    
    /// Get the issuer identification number (IIN) of the card issuer encoded in the barcode
    /// - Parameter data: Barcode data
    /// - Returns:Identification number of the card issuer encoded in the barcode or `nil` if the barcode doesn't follow the AAMVA-spec
    /// - Since: 1.0.0
    public func iin(from data: Data) -> String? {
        if data[0] == 0x40 {
            return String(data: data[9..<15], encoding: .utf8)
        }
        guard let parsed = try? AAMVABarcodeParser().parseData(data) else {
            return nil
        }
        return parsed["IIN"]
    }
}
