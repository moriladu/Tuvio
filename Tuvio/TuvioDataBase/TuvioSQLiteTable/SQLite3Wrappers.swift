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
 Errors to throw.
 */
enum Errors: Error {
    case cantCreateConnection(String)
    case connectionNotOpened(String)
    case unknownError(String)
}

/**
 Describes the correct syntax of the underlying programming language.
 This is as such to make it easy for a user to identify data types when creating table
 and assigning some columns.
 
 Types supported sofar:
 ```
 Nil - for null values.
 Int - for integers.
 Double - for doubles, which includes decimals and large numbers.
 String - for all string related values.
 ```
 
 **Abstract State:** maps variable names identifying data types to the correct syntax for each type.
 */
public enum SQLiteTypes: String {
    case Int = "INTEGER"
    case Nil = "NULL"
    case Double = "REAL"
    case String = "TEXT"
}


/**
 Creates a swift wrapping around the C functions of the SQLite3
 functions.
 
 Here's how to create a database table:
```
 - First open a connection, by giving the address to where a table should be save.
 
 - Prepare the connection, by giving the names to the columns
 
```
 **Abstract State:** SQLite3Wrappers contains a bunch of functions to wrap
                 C functionalities for swift compatibility.
 */
class SQLiteWrappers {
    /**
     Constants for creating a new table, if one doesn't exists.
     */
    private static let createTable = "CREATE TABLE IF NOT EXISTS"
    
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
        if (sqlite3_open(fileURL.path, &database) != SQLITE_OK) {
            let errMsg = String(cString: sqlite3_errmsg(database))
            throw Errors.cantCreateConnection("CAN'T CREATE CONNECTION: \(errMsg)")
        } else {
            connected = true
        }
    }
    
    /**
     Prepares the database for querying, by creating a new table if no previous table exists.
     
     **Requires:** that a database connection is open.
     
     - Parameter columns: a dictionary that maps the name of columns to their data types.
     - Parameter tableName: what to name the new table.
     */
    public static func prepareConnection(tableName: String, columns: [String: String]) throws {
        let valid = checkDataTypes(dataTypes: Array(columns.values))
        if !(connected) {
            throw Errors.connectionNotOpened("THERE IS NO OPEN CONNECTION!")
        } else if !(valid) {
            throw Errors.unknownError("AN INCORRECT DATATYPE IS ENTERRED!")
        } else {
            var sqlStatement = createTable + " " + tableName + " ("
            for column in columns {
                sqlStatement = column.key + " " + column.value + ", "
            }
            sqlStatement = sqlStatement + ")"
            
            if sqlite3_exec(database, sqlStatement, nil, nil, nil) != SQLITE_OK {
                let errorMsg = String(cString: sqlite3_errmsg(database)!)
                throw Errors.unknownError(errorMsg)
            }
        }
    }
    
    /**
     A helper method for the prepareConnection function; helps to make sure all data types
     are valid syntaxes.
     */
    private static func checkDataTypes(dataTypes: [String]) -> Bool {
        let valid = (dataTypes.count > 1)
        for type in dataTypes {
            switch type {
            case SQLiteTypes.Nil.rawValue,
                 SQLiteTypes.Int.rawValue,
                 SQLiteTypes.Double.rawValue,
                 SQLiteTypes.String.rawValue:
                continue
            default:
                return false
            }
        }
        return valid
    }
    
    /**
     Inserts a new row to the table.
     
     - Parameter row: the row to insert to the database table.
     */
    public static func addEntry(row: TuvioUser) {
        // finish this function. and add tests.
    }
    
    
    
    /**
        Closes the connection.
     */
    public static func closeConnection() {
        connected = (sqlite3_close(database) == SQLITE_BUSY) ? false : true
        print(connected)
    }
}
