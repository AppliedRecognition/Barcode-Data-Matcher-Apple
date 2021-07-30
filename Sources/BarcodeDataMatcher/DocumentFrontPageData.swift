//
//  DocumentFrontData.swift
//  BarcodeDataMatcher
//
//  Created by Jakub Dolejs on 28/06/2021.
//

import Foundation
import AAMVABarcodeParser

/// Representation of document data found on the front of ID cards
/// - Since: 1.0.0
public class DocumentFrontPageData: BarcodeMatching {
    
    /// Document holder's first name
    public let firstName: String
    /// Document holder's last name
    public let lastName: String
    /// Document holder's full address
    public let address: String
    /// Document date of issue
    public let dateOfIssue: Date
    /// Document holder's date of birth
    public let dateOfBirth: Date
    /// Document date of expiry
    public let dateOfExpiry: Date
    /// Document number
    public let documentNumber: String
    /// Parser to use for parsing the barcode data prior to comparison
    public var parser: BarcodeParsing
    
    /// Initializer
    /// - Parameters:
    ///   - firstName: Document holder's first name
    ///   - lastName: Document holder's last name
    ///   - address: Document holder's full address
    ///   - dateOfBirth: Document holder's date of birth
    ///   - documentNumber: Document number
    ///   - dateOfIssue: Document date of issue
    ///   - dateOfExpiry: Document date of expiry
    /// - Since: 1.0.0
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
    
    /// Match the front page to the given barcode data
    /// - Parameter barcodeData: Barcode data to match against
    /// - Throws: Error if the matching fails
    /// - Returns: Similarity score between the front page data and the barcode data (0 = no match, 1 = full match)
    /// - Since: 1.0.0
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
        let oneDay: TimeInterval = 24 * 60 * 60 * 1000
        let dateScore: Float = dates.reduce(0, { score, tuple in
            guard let challenge = tuple.1, let date = (dateFormatter as? DateFormatter)?.date(from: challenge) ?? (dateFormatter as? ISO8601DateFormatter)?.date(from: challenge) else {
                return score
            }
            let timeDiff = abs(date.timeIntervalSince1970 - tuple.0.timeIntervalSince1970)
            return score + (timeDiff < oneDay ? 1 : 0)
        }) / Float(dates.count)
        return (stringScore + dateScore) / 2
    }
}
