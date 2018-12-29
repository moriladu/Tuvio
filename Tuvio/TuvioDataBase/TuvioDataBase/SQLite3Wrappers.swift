//
//  SQLite3Wrappers.swift
//  TuvioDataBase
//
//  Created by 20eml5 on 12/28/18.
//  Copyright © 2018 20eml5. All rights reserved.
//

import Foundation
import SQLite3

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
     Creates a connection
     */
    public static func createConnection(fileURL: URL) throws {
        let connection = sqlite3_open(fileURL.path, &database)
        if connection != SQLITE_OK {
            throw Errors.cantCreateConnection("Can't create connection: \(connection)")
        } else {
            
        }
    }
    
    /**
        Closes a connection.
     */
    
}


