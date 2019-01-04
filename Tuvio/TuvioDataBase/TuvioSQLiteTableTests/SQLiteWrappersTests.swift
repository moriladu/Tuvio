//
//  SQLiteWrappersTests.swift
//  TuvioDataBaseTests
//
//  Created by 20eml5 on 12/30/18.
//  Copyright © 2018 20eml5. All rights reserved.
//
import XCTest
import Foundation
@testable import TuvioSQLiteTable


public class SQLiteWrappersTests: XCTestCase {
    /**
     Reference to the file URL
     */
    private var fileURL: URL?
    
    /**
     Opens a file url for database querying.
     */
    func openFileURL() throws {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            fileURL = documentDirectory.appendingPathComponent("TuvioUsers.sqlite3")
        }
        catch {
            throw Errors.cantCreateConnection("No connection!")
        }
    }
    
    /**
     Test opening a database connection.
     */
    func testOpenConnection() {
        XCTAssertNoThrow(try! openFileURL())
        XCTAssertNoThrow(try SQLiteWrappers.createConnection(fileURL: fileURL!))
        XCTAssertNoThrow(try SQLiteWrappers.prepareConnection(tableName: "mori", columns: []))
    }
    
    func testRandom() {
        let user1 = DataBaseEntry(id: 0, name: "Kevin Durant", age: 8, ipAddress: "0.2.123.878", uniqueAddress: "01267 MA")
        let user2 = DataBaseEntry(id: 1, name: "Klay Thompson", age: 22, ipAddress: "01.002.036.785", uniqueAddress: "Osborn Juba")
//        DataBaseEntries.DATA.addEntry(entry: user1)
//        DataBaseEntries.DATA.addEntry(entry: user2)
        DataBaseEntries.DATA.listEntries()
        
        DataBaseEntries.DATA.deleteEntry(entry: user2)
        DataBaseEntries.DATA.listEntries()
    }
}
