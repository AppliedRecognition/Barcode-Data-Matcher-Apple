//
//  BarcodeMatching.swift
//  BarcodeDataMatcher
//
//  Created by Jakub Dolejs on 29/06/2021.
//

import Foundation

public protocol BarcodeMatching {
    
    func match(_ barcodeData: Data) throws -> Float
}
