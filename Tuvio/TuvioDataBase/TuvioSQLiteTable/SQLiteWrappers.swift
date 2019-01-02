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
     A database connection to be have.
     */
    private static var database: OpaquePointer? = nil
    
    /**
     A flag state whether there's an active database connection.
     */
    private static var connected: Bool = false
    
    /**
     The name of the sql table open.
     */
    private static var TABLE_NAME: String!
    
    /**
     Creates a connection to the directory and filename specified
     by the fileURL input.
     
     **Effects:** Creates a database given the fileURL if one doesn't exists, or opens
     an existing database with the given fileURL.
     
     - Parameter fileURL: the address to save the database or where to read the data from.
     */
    static func createConnection(fileURL: URL) throws {
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
    static func prepareConnection(tableName: String, columns: [String: String]) throws {
        assert(connected, "Connection is not opened!!")
        let valid = checkDataTypes(dataTypes: Array(columns.values))
        if !(valid) {
            throw Errors.unknownError("Incorrect Data type is enterred!")
        } else {
            let sqlStatement = SQLGenerator.getCreateTableStatement(for: tableName, with: columns)
            var stmt: OpaquePointer? = nil
            if sqlite3_prepare_v2(database, sqlStatement, -1, &stmt, nil) == SQLITE_OK {
                if sqlite3_step(stmt) != SQLITE_DONE {
                    throw Errors.unknownError("Contact table could not be created!")
                }
                self.TABLE_NAME = tableName
            } else {
                throw Errors.unknownError("Can't prepare the database for table creation!")
            }
            sqlite3_finalize(stmt)
        }
    }
    
    /**
     A helper method for the prepareConnection function; helps to make sure all data types
     are valid syntaxes.
     
     - Parameter dataTypes: specifies the supported data types.
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
    static func addEntry(row: DataBaseEntry) throws {
        assert(connected)
        let insertStatement = SQLGenerator.getInsertStatement(for: TABLE_NAME!, entry: row)
        var stmt: OpaquePointer? = nil

        //preparing the query
        if sqlite3_prepare(database, insertStatement, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            throw Errors.unknownError(errmsg)
        }

        let values = row.getValues().components(separatedBy: ", ")
        
        for i in 0..<values.count {
            //binding the parameters
            if let digit = Int32(values[i]) {
                if sqlite3_bind_int(stmt, Int32(i + 1), digit) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(database)!)
                    throw Errors.unknownError("failure binding name: \(errmsg)")
                }
            } else {
                if sqlite3_bind_text(stmt, Int32(i + 1), values[i], -1, nil) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(database)!)
                    throw Errors.unknownError("failure binding name: \(errmsg)")
                }
            }
        }
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            throw Errors.unknownError("Error in Inserting: \(errmsg)")
        }
        
        sqlite3_finalize(stmt)
    }
    
    /**
     Deletes an entry from the table.
     
     - Parameter entry: the entry to delete
     */
    static func deleteEntry(entry: DataBaseEntry) throws {
        let deleteStatement = SQLGenerator.getDeleteStatement(for: TABLE_NAME, entry: entry)
        var stmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(database, deleteStatement, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(database))
                throw Errors.unknownError("Could not delete row: \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(database))
            throw Errors.unknownError("DELETE statement could not be prepared: \(errmsg)")
        }
        
        sqlite3_finalize(stmt)
    }
    
    /**
     Traverses through the table and read the values out.
     */
    static func readTable()  throws -> [DataBaseEntry] {
        assert(connected)
        //this is our select query
        let queryString = "SELECT * FROM \(String(describing: TABLE_NAME))"
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            throw Errors.unknownError(errmsg)
        }
        // list of all entries.
        var entries: [DataBaseEntry] = []
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let name = String(cString: sqlite3_column_text(stmt, 0))
            let age = Int(sqlite3_column_int(stmt, 1))
            let ip = String(cString: sqlite3_column_text(stmt, 2))
            let address = String(cString: sqlite3_column_text(stmt, 3))
            
            //adding values to list
            entries.append(DataBaseEntry(name: name, age: age, ipAddress: ip, uniqueAddress: address))
        }
        sqlite3_finalize(stmt)
        return entries
    }
    
    /**
     Closes the connection.
     */
    public static func closeConnection() {
        connected = (sqlite3_close(database) == SQLITE_BUSY)
    }
}
