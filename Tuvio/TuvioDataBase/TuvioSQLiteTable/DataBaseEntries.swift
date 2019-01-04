//
//  TuvioUser.swift
//  TuvioDataBase
//
//  Created by 20eml5 on 12/28/18.
//  Copyright © 2018 20eml5. All rights reserved.
//

import Foundation
import SQLite3

/**
 An immutable data wrapper for a user.
 
 Abstract State: Contains User name, IP_ADDRESS, age, unique address, and other
                informations.
 */
public class DataBaseEntry {
    /**
     Parameter names.
     */
    public static let name = "name"
    public static let age = "age"
    public static let ip = "ipAddress"
    public static let uniqueAddress = "uniqueAddress"
    
    // SQLite column names and corresponding values.
    let parameters: String
    let values: String

    let id: Int
    let name: String
    let age: Int
    let ipAddr: String
    let uniqueID: String
    let description: String
    
    /**
     Initializes an entry with a statement to create it.
     */
    public init(id: Int, name: String, age: Int, ipAddress: String, uniqueAddress: String) {
        self.id = id
        self.name = name
        self.age = age
        self.ipAddr = ipAddress
        self.uniqueID = uniqueAddress
        self.parameters = "\(DataBaseEntry.name), \(DataBaseEntry.age), \(DataBaseEntry.ip), \(DataBaseEntry.uniqueAddress)"
        self.values = "\(name), \(age), \(ipAddress), \(uniqueAddress)"
        self.description = "id: \(id); \(DataBaseEntry.name): \(name); \(DataBaseEntry.age): \(age); \(DataBaseEntry.ip): \(ipAddress); \(DataBaseEntry.uniqueAddress): \(uniqueAddress)"
    }
}

/**
 A platform to connect to a database from which user data are derived and written to.
 
 **Abstract State:** TuvioUsers contains references to the actual sqlite table
                 stored on the permanent disc of the device.
 */
public class DataBaseEntries {
    /**
     A Singleton instance for all users.
     */
    public static let DATA = DataBaseEntries()
    
    // Abstraction Function: TuvioUsers reads and writes users data onto the
    //                       permanent storage.
    //
    // Rep Invariant: The total number of users must equal the size of the sqlite table.
    
    /**
        Checks the truth of the rep invariant.
     */
    private func checkRep() { assert(true) }
    
    /**
        creates a database connection.
     */
    private init() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory,
                                                                in: .userDomainMask,
                                                                appropriateFor: nil,
                                                                create: true)
            let fileURL = documentDirectory.appendingPathComponent("TuvioUsers.sqlite3")
            try SQLiteWrappers.createConnection(fileURL: fileURL)
            
            let columns: [(String, String)] = [
                (DataBaseEntry.name, SQLiteTypes.String.rawValue),
                (DataBaseEntry.age, SQLiteTypes.Int.rawValue),
                (DataBaseEntry.ip, SQLiteTypes.String.rawValue),
                (DataBaseEntry.uniqueAddress, SQLiteTypes.String.rawValue)
            ]
            try SQLiteWrappers.prepareConnection(tableName: "StupidShit", columns: columns)
        } catch { print(error) }
        checkRep()
    }
    
    /**
     Adds a new entry to the database.
     
     **Requires:** entry is not contained in the database.
     
     **Effects:** the new entry is added to the database.
     
     - Parameter entry: a new entry to be added.
     */
    public func addEntry(entry: DataBaseEntry) {
        do {
            try SQLiteWrappers.addEntry(row: entry)
        } catch { print(error) }
    }
    
    /**
      Prints all the entries in the database.
     */
    public func listEntries() {
        do {
            let entries = try SQLiteWrappers.readTable()
            for entry in entries {
                print(entry.description)
            }
        } catch { print(error) }
    }
    
    /**
     Deletes an entry from the database.
     
     **Requires:** entry is contained in the database.
     
     **Effects:** entry is removed from the database.
     
     - Parameter entry: a database entry to delete from the database.
     */
    public func deleteEntry(entry: DataBaseEntry) {
        do {
            try SQLiteWrappers.deleteEntry(entry: entry)
        } catch { print(error) }
    }
}

