//
//  CoreDataStack.swift
//
//  Created by Alex Givens http://alexgivens.com on 7/23/17
//  Copyright © 2017 Noon Pacific LLC http://noonpacific.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  Reference
//  https://swifting.io/blog/2016/09/25/25-core-data-in-ios10-nspersistentcontainer/
//  https://stackoverflow.com/a/41598487/4197332


import Foundation
import CoreData


final public class CoreDataStack {
    
    static public let sharedStack = CoreDataStack()
    
    var errorHandler: (Error) -> Void = {_ in }
    
    private init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(mainContextChanged(notification:)),
                                               name: .NSManagedObjectContextDidSave,
                                               object: self.managedObjectContext)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(bgContextChanged(notification:)),
                                               name: .NSManagedObjectContextDidSave,
                                               object: self.backgroundManagedObjectContext)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    lazy var libraryDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        
        var rawBundle: Bundle? {
            
            if let bundle = Bundle(identifier: "org.cocoapods.WhiteLabel") {
                return bundle
            }
            
            guard
                let resourceBundleURL = Bundle(for: type(of: self)).url(forResource: "WhiteLabel", withExtension: "bundle"),
                let realBundle = Bundle(url: resourceBundleURL)
            else {
                return nil
            }
            
            return realBundle
        }
        
        guard let bundle = rawBundle else {
            print("Could not get bundle that contains the model ")
            return NSManagedObjectModel()
        }
        
        guard
            let modelURL = bundle.url(forResource: "WhiteLabel", withExtension: "momd")
        else {
            print("Could not get bundle for managed object model")
            return NSManagedObjectModel()
        }
        
        return NSManagedObjectModel(contentsOf: modelURL) ?? NSManagedObjectModel()

    }()
    
    lazy public var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.libraryDirectory.appendingPathComponent("WhiteLabel.sqlite")
        do {
            try coordinator.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: url,
                options: [
                    NSMigratePersistentStoresAutomaticallyOption: true,
                    NSInferMappingModelAutomaticallyOption: true
                ]
            )
        } catch {
            // Report any error we got.
            NSLog("CoreData error \(error), \(String(describing: error._userInfo))")
            self.errorHandler(error)
        }
        return coordinator
    }()
    
    lazy public var backgroundManagedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateManagedObjectContext.persistentStoreCoordinator = coordinator
        return privateManagedObjectContext
    }()
    
    lazy public var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainManagedObjectContext.persistentStoreCoordinator = coordinator
        return mainManagedObjectContext
    }()
    
    @objc func mainContextChanged(notification: NSNotification) {
        backgroundManagedObjectContext.perform { [unowned self] in
            self.backgroundManagedObjectContext.mergeChanges(fromContextDidSave: notification as Notification)
        }
    }
    
    @objc func bgContextChanged(notification: NSNotification) {
        managedObjectContext.perform{ [unowned self] in
            self.managedObjectContext.mergeChanges(fromContextDidSave: notification as Notification)
        }
    }
    
    public class func deleteEntity(name: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        let moc = CoreDataStack.sharedStack.managedObjectContext
        do {
            let result = try moc.execute(deleteRequest) as? NSBatchDeleteResult
            if let objectIDArray = result?.result as? [NSManagedObjectID] {
                let changes = [NSDeletedObjectsKey : objectIDArray]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [moc])
            }
        } catch let error as NSError {
            print("Unable to delete \(name)s: \(error.userInfo)")
        }
    }
    
}
