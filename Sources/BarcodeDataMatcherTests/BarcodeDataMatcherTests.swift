//
//  Barcode_Data_MatcherTests.swift
//  Barcode-Data-MatcherTests
//
//  Created by Jakub Dolejs on 25/06/2021.
//

import XCTest
import AAMVABarcodeParser
@testable import BarcodeDataMatcher

class BarcodeDataMatcherTests: XCTestCase {

    func testStringDistance() throws {
        XCTAssertEqual(try DamerauLevenshtein.distance(between: "one", and: "two").steps, 3)
    }
    
    func testIIN() throws {
        let bcData = try self.barcodeData("1")
        let bcIIN = AAMVABarcodeHelper.default.iin(from: bcData)
        let vaData = try self.barcodeData("2")
        let vaIIN = AAMVABarcodeHelper.default.iin(from: vaData)
        let txData = try self.barcodeData("3")
        let txIIN = AAMVABarcodeHelper.default.iin(from: txData)
        let onData = try self.barcodeData("4")
        let onIIN = AAMVABarcodeHelper.default.iin(from: onData)
        XCTAssertEqual("636028", bcIIN)
        XCTAssertEqual("636000", vaIIN)
        XCTAssertEqual("636015", txIIN)
        XCTAssertEqual("636012", onIIN)
    }
    
    func testAAMVAVersion() throws {
        let bcData = try self.barcodeData("1")
        let bcVersion = AAMVABarcodeHelper.default.aamvaSpecVersion(from: bcData)
        let vaData = try self.barcodeData("2")
        let vaVersion = AAMVABarcodeHelper.default.aamvaSpecVersion(from: vaData)
        let txData = try self.barcodeData("3")
        let txVersion = AAMVABarcodeHelper.default.aamvaSpecVersion(from: txData)
        let onData = try self.barcodeData("4")
        let onVersion = AAMVABarcodeHelper.default.aamvaSpecVersion(from: onData)
        XCTAssertNil(bcVersion)
        XCTAssertEqual(8, vaVersion)
        XCTAssertEqual(3, txVersion)
        XCTAssertEqual(3, onVersion)
    }
    
    func testONDLMatching() throws {
        let frontPage = self.createFrontPage(firstName: "ABDULAH,M", lastName: "ABBOTT", address: "5619 LAKEHILL CRES\nBURLINGTON, ON\nL7N 1B9", documentNumber: "G0463-64356-00901", dateOfBirth: "1960/09/01", dateOfExpiry: "2020/09/01", dateOfIssue: "2015/08/28")
        let score = try self.match(barcodeNumber: "4", frontPage: frontPage)
        XCTAssertEqual(score, 1)
    }
    
    func testVADLMatching() throws {
        let frontPage = self.createFrontPage(firstName: "MICHAEL", lastName: "SAMPLE", address: "2300 WEST BROAD STREET\nRICHMOND, ON\n232690000", documentNumber: "T64235789", dateOfBirth: "1986/06/06", dateOfExpiry: "2013/12/10", dateOfIssue: "2008/06/06")
        let score = try self.match(barcodeNumber: "2", frontPage: frontPage)
        XCTAssertEqual(score, 1)
    }
    
    private func barcodeData(_ barcodeNumber: String) throws -> Data {
        guard let barcodeURL = Bundle(for: type(of: self)).url(forResource: barcodeNumber, withExtension: "txt", subdirectory: "barcode_data") else {
            throw NSError()
        }
        return try Data(contentsOf: barcodeURL)
    }
    
    private func match(barcodeNumber: String, frontPage: DocumentFrontPageData) throws -> Float {
        let barcodeData = try self.barcodeData(barcodeNumber)
        return try frontPage.match(barcodeData)
    }
    
    private func createFrontPage(firstName: String, lastName: String, address: String, documentNumber: String, dateOfBirth: String, dateOfExpiry: String, dateOfIssue: String) -> DocumentFrontPageData {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return DocumentFrontPageData(firstName: firstName, lastName: lastName, address: address, dateOfBirth: dateFormatter.date(from: dateOfBirth)!, documentNumber: documentNumber, dateOfIssue: dateFormatter.date(from: dateOfIssue)!, dateOfExpiry: dateFormatter.date(from: dateOfExpiry)!)
    }
}
