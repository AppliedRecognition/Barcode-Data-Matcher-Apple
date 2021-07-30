//
//  DocumentFrontData.swift
//  BarcodeDataMatcher
//
//  Created by Jakub Dolejs on 28/06/2021.
//

import Foundation
import AAMVABarcodeParser

public class DocumentFrontPageData: BarcodeMatching {
    
    public let firstName: String
    public let lastName: String
    public let address: String
    public let dateOfIssue: Date
    public let dateOfBirth: Date
    public let dateOfExpiry: Date
    public let documentNumber: String
    public var parser: BarcodeParsing
    
    public init(firstName: String, lastName: String, address: String, dateOfBirth: Date, documentNumber: String, dateOfIssue: Date, dateOfExpiry: Date) {
        self.firstName = firstName
        self.lastName = lastName
        self.address = address
        self.dateOfBirth = dateOfBirth
        self.documentNumber = documentNumber
        self.dateOfIssue = dateOfIssue
        self.dateOfExpiry = dateOfExpiry
        self.parser = AAMVABarcodeParser()
    }
    
    public func match(_ barcodeData: Data) throws -> Float {
        let data = try self.parser.parseData(barcodeData)
        let strings: [(String,String?)] = [
            (self.firstName, data.firstName),
            (self.lastName, data.lastName),
            (self.documentNumber, data.documentNumber),
            (self.address, data.address)
        ]
        let stringScore: Float = try strings.reduce(0, { score, tuple in
            guard let challenge = tuple.1 else {
                return score
            }
            return try score + tuple.0.match(challenge)
        }) / Float(strings.count)
        let dates: [(Date,String?)] = [
            (self.dateOfBirth, data.dateOfBirth),
            (self.dateOfIssue, data.dateOfIssue),
            (self.dateOfExpiry, data.dateOfExpiry)
        ]
        let dateFormatter: Formatter
        if let doi = data.dateOfIssue, doi.count <= 8 {
            dateFormatter = DateFormatter()
            (dateFormatter as! DateFormatter).timeStyle = .none
            if let year = Int(String(doi[doi.startIndex..<doi.index(doi.startIndex, offsetBy: 4)])), year > 1940 && year <= Calendar(identifier: .iso8601).component(.year, from: Date()) {
                (dateFormatter as! DateFormatter).dateFormat = "yyyyMMdd"
            } else {
                (dateFormatter as! DateFormatter).dateFormat = "ddMMyyyy"
            }
        } else {
            dateFormatter = ISO8601DateFormatter()
        }
        let dateScore: Float = dates.reduce(0, { score, tuple in
            guard let challenge = tuple.1, let date = (dateFormatter as? DateFormatter)?.date(from: challenge) ?? (dateFormatter as? ISO8601DateFormatter)?.date(from: challenge) else {
                return score
            }
            return score + (date.distance(to: tuple.0) < 24 * 60 * 60 * 1000 ? 1 : 0)
        }) / Float(dates.count)
        return (stringScore + dateScore) / 2
    }
}
