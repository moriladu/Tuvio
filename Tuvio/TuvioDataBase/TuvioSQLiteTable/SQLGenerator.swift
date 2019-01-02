//
//  SQLGenerator.swift
//  TuvioSQLiteTable
//
//  Created by 20eml5 on 12/31/18.
//  Copyright © 2018 20eml5. All rights reserved.
//

import Foundation

/**
 This class contains static methods used in generating valid sql statements
 to be executed by the SQLiteWrappers class in creating a database, adding an entry, deleting an
 entry, and many other functionalities.
 */
class SQLGenerator {
    /**
     Gets an sql statement for creating a new table if there's not one
     with the same name.
     
     - Parameter columns: a dictionary that maps the name of columns to their data types.
     - Parameter tableName: what to name the new table.
     */
    static func getCreateTableStatement(for table: String, with entries: [String:String]) -> String {
        var sqlStatement = "CREATE TABLE IF NOT EXISTS " + table + " ("
        var count = 0
        for column in entries {
            if (count != (entries.count - 1)) {
                sqlStatement = sqlStatement + column.key + " " + column.value + ", "
            } else {
                sqlStatement = sqlStatement + column.key + " " + column.value + ");"
            }
            count = count + 1
        }
        return sqlStatement
    }
    
    
    /**
     Gets the sql statement for inserting a new entry to the database.
     
     // modify a way to get the parameter
     I dont know if this actually works.
     */
    static func getInsertStatement(for table: String, entry: DataBaseEntry) -> String {
        let insertStatement = "INSERT INTO \(table) (\(entry.getParameters())) VALUES (\(entry.getValues()))"
        
        return insertStatement
    }
    
    /**
     Gets an sql statement for deleting an existing row in a database.
     */
    static func getDeleteStatement(for table: String, entry: DataBaseEntry) -> String {
        let parameters = entry.getParameters().components(separatedBy: ", ")
        let values = entry.getValues().components(separatedBy: ", ")
        
        assert(values.count == parameters.count)
        
        var condition: String?
        
        for i in 0..<values.count {
            if (condition != nil) {
                condition = condition! + " AND \(parameters[i]) = \(values[i])"
            } else {
                condition = "\(parameters[i]) = \(values[i]) "
            }
        }
        
        let deleteStatement = "DELETE FROM \(table) WHERE \(condition ?? "FALSE");"
        return deleteStatement
    }
}
