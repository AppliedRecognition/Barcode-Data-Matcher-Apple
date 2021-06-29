//
//  AAMVABarcodeHelper.swift
//  BarcodeDataMatcher
//
//  Created by Jakub Dolejs on 29/06/2021.
//

import Foundation
import AAMVABarcodeParser

public class AAMVABarcodeHelper {
    
    private init() {
    }
    
    public static let `default`: AAMVABarcodeHelper = AAMVABarcodeHelper()
    
    public func aamvaSpecVersion(from data: Data) -> Int? {
        guard data[0] == 0x40 else {
            return nil
        }
        guard let str = String(data: data[15..<17], encoding: .utf8) else {
            return nil
        }
        return Int(str)
    }
    
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
