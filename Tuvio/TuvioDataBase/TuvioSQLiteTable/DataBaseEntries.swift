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
    public static let np = "Name"
    public static let age = "Age"
    public static let ip = "IP_Address"
    public static let id = "uniqueAddress"
    
    // SQLite column names and corresponding values.
    private var parameters: String = ""
    private var values: String = ""

    /**
     Initializes an entry with a statement to create it.
     */
    public init(name: String, age: Int, ipAddress: String, uniqueAddress: String) {
        self.parameters = "\(DataBaseEntry.np), \(DataBaseEntry.age), \(DataBaseEntry.ip), \(DataBaseEntry.id)"
        self.values = "\(name), \(age), \(ipAddress), \(uniqueAddress)"
    }
    
    func getParameters() -> String { return parameters }
    func getValues() -> String { return values }
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
            
            let columns: [String: String] = [
                DataBaseEntry.np: SQLiteTypes.String.rawValue,
                DataBaseEntry.age: SQLiteTypes.Int.rawValue,
                DataBaseEntry.ip: SQLiteTypes.String.rawValue,
                DataBaseEntry.id: SQLiteTypes.String.rawValue
            ]
            try SQLiteWrappers.prepareConnection(tableName: "StupidShit", columns: columns)
        } catch {
            print(error)
        }
        checkRep()
    }
    
    public func addEntry(entry: DataBaseEntry) {
        do {
            try SQLiteWrappers.addEntry(row: entry)
        } catch {
            print(error)
        }
    }
    
    public func listEntries() {
        do {
            let entries = try SQLiteWrappers.readTable()
            for entry in entries {
                var row: String = ""
                let parameters = entry.getParameters().components(separatedBy: ", ")
                let values = entry.getValues().components(separatedBy: ", ")
                for i in 0..<values.count {
                    row = row + "\(parameters[i]) = \(values[i]) "
                }
                print(row)
            }
        } catch {
            print(error)
        }
    }
}

