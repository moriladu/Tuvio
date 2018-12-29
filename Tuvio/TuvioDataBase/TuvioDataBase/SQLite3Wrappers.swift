//
//  SQLite3Wrappers.swift
//  TuvioDataBase
//
//  Created by 20eml5 on 12/28/18.
//  Copyright © 2018 20eml5. All rights reserved.
//

import Foundation
import SQLite3

/**
    Errors
 */
enum Errors: Error {
    case cantCreateConnection(String)
    case unknownError
}

/**
 Creates a swift wrapping around the C functions of the SQLite3
 functions.

 Abstract State: SQLite3Wrappers contains a bunch of functions to wrap
                 C functionalities for swift compatibility.
 */
class SQLiteWrappers {
    /**
     A database connection to be have.
     */
    private static var database: OpaquePointer? = nil
    
    /**
     A flag state whether there's an active database connection.
     */
    private static var connected: Bool = false
    
    /**
        Creates a connection to the directory and filename specified
        by the fileURL input.
     
     **Effects:** Creates a database given the fileURL if one doesn't exists, or opens
                  an existing database with the given fileURL.
     
     - Parameter fileURL: the address to save the database or where to read the data from.
     */
    public static func createConnection(fileURL: URL) throws {
        let connection = sqlite3_open(fileURL.path, &database)
        if connection != SQLITE_OK {
            connected = false
            throw Errors.cantCreateConnection("Can't create connection: \(connection)")
        }
        connected = true
    }
    
    /**
     Prepares the database for querying.
     */
    private static func prepare() {
        sqlite3_prepare
    }
    
    
    /**
        Closes the connection.
     */
    public static func closeConnection() {
        connected = (sqlite3_close(database) == SQLITE_BUSY) ? false : true
        print(connected)
    }
}


