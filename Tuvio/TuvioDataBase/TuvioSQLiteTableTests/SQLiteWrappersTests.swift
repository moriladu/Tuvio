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
    }
    
    
}
