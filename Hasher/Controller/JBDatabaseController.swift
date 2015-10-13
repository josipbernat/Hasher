//
//  JBDatabaseController.swift
//  Hasher
//
//  Created by Josip Bernat on 13/10/15.
//  Copyright © 2015 Josip Bernat. All rights reserved.
//

import Cocoa

class JBDatabaseController: NSObject {

    private struct databaseInfo {
        
        var name = "HasherDatabase"
        var type = "sqlite"
        var tableName = "cached_hashes"
        var openedForWrite = false
        
        func fullName() -> String {
            return String(format: "%@.%@", self.name, self.type)
        }
    }
   
    private var kDatabaseInfo = databaseInfo()
    private var databaseQueue: FMDatabaseQueue!
    private var operationQueue = NSOperationQueue()
    
    internal static let sharedInstance = JBDatabaseController()
    
    //MARK: - Deinit
    
    deinit {
    
        if let unwrappedQueue = databaseQueue {
            unwrappedQueue.close()
        }
    }
    
    //MARK: - Initialization
    
    func start() {
        
        print("Starting JBDatabaseController")
        initializeDatabase()
    }
    
    override init() {
        super.init()
        
        start()
        
        operationQueue.maxConcurrentOperationCount = 1
    }
    
    private func initializeDatabase() {
        
        var documentFolderPath = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true)[0] as String
        documentFolderPath = documentFolderPath.stringByAppendingString("/Hasher")
        
        let dbFilePath = documentFolderPath.stringByAppendingString("/" + kDatabaseInfo.fullName())
        
        if NSFileManager.defaultManager().fileExistsAtPath(documentFolderPath) == false {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(documentFolderPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
            }
        }
        
        databaseQueue = FMDatabaseQueue(path: dbFilePath)
        databaseQueue.inDatabase { (database) -> Void in
            
            if database.open() {
                
                let statement = "CREATE TABLE IF NOT EXISTS cached_hashes (KEY TEXT NOT NULL, TYPE VARCHAR(5));"
                if database.executeUpdate(statement, withArgumentsInArray: nil) == true {
                    self.kDatabaseInfo.openedForWrite = true
                    print("Database setup successfull")
                }
                else {
                    print("Failed to create table")
                }
            }
        }
    }
    
    //MARK: - Writing
    
    func saveToDatabse(value: String, type: String) {
    
        operationQueue.addOperationWithBlock { () -> Void in
            
            self.databaseQueue.inDatabase({ (database: FMDatabase!) -> Void in
                
                let statement = String(format: "INSERT INTO %@ VALUES(\"%@\", \"%@\")", self.kDatabaseInfo.tableName, value, type)
                if let result = database.executeQuery(statement, withArgumentsInArray: nil) {
                    print(result.query)
                    result.close()
                }
            })
        }
    }
}
