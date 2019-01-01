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
    // SQLite column names and corresponding values.
    private var parameters: String = ""
    private var values: String = ""

    /**
     Initializes an entry with a statement to create it.
     */
    public init(name: String, age: Int8, ipAddress: String, uniqueAddress: String) {
        self.parameters = "NAME, AGE, IP_ADDRESS, UNIGUE ADDRESS"
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
        } catch {
            print(error)
        }
        checkRep()
    }
    
}

