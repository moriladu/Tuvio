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

public struct TuvioUser {
    /**
     Information on a user.
     */
    let name: String
    let age: Int8
    let IP_ADDRESS: String
    let uniqueAddress: String
}

/**
 A platform to connect to a database from which user data are derived and written to.
 
 **Abstract State:** TuvioUsers contains references to the actual sqlite table
                 stored on the permanent disc of the device.
 */
public class TuvioUsers {
    /**
     A Singleton instance for all users.
     */
    public static let DATA = TuvioUsers()
    
    // Abstraction Function: TuvioUsers reads and writes users data onto the
    //                       permanent storage.
    //
    // Rep Invariant: The total number of users must equal the size of the sqlite table.
    
    /**
        Checks the truth of the rep invariant.
     */
    private func checkRep() { assert(true) }
    
    /**
        The database connection.
     */
    var dataBase: OpaquePointer?
    
    /**
        creates a database connection.
     */
    private init() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("TuvioUsers.sqlite3")
            
            if sqlite3_open(fileURL.path, &dataBase) != SQLITE_OK {
                
            }
            
        } catch {
            print(error)
        }
        checkRep()
    }
    
}

