//
//  WLMixtape+CoreDataClass.swift
//
//  Created by Alex Givens http://alexgivens.com on 7/24/17
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

import Foundation
import CoreData

@objc(WLMixtape)
final public class WLMixtape: NSManagedObject, ResponseObjectSerializable, ResponseCollectionSerializable {
    
    public static let entityName = "WLMixtape"
    
    public var collection: WLCollection? {
        return WLCollection.collection(forID: self.collectionID)
    }
    
    public var tracks: [WLTrack]? {
        return WLTrack.tracks(forMixtape: self)
    }
    
    // MARK: Mixtape retrieval
    
    public class func mixtape(forID id: Int32) -> WLMixtape? {
        let context = CoreDataStack.shared.backgroundManagedObjectContext
        let fetchRequest: NSFetchRequest<WLMixtape> = WLMixtape.fetchRequest()
        let predicate = NSPredicate(format: "id == \(id)")
        fetchRequest.predicate = predicate
        do {
            let mixtape = try context.fetch(fetchRequest).first
            return mixtape
        } catch let error as NSError {
            print("Unable to retrieve mixtape for ID \(id): \(error.userInfo)")
            return nil
        }
    }
    
    public class func mixtapes(forCollection collection: WLCollection) -> [WLMixtape]? {
        return WLMixtape.mixtapes(forCollectionID: collection.id)
    }
    
    public class func mixtapes(forCollectionID collectionID: Int32) -> [WLMixtape]? {
        let fetchRequest = WLMixtape.sortedFetchRequest(forCollectionID: collectionID)
        let context = CoreDataStack.shared.backgroundManagedObjectContext
        do {
            let mixtapes = try context.fetch(fetchRequest)
            return mixtapes
        } catch let error as NSError {
            print("Unable to get mixtapes for collection ID \(collectionID): \(error.userInfo)")
            return nil
        }
    }
    
    public class func sortedFetchRequest(forCollection collection: WLCollection) -> NSFetchRequest<WLMixtape> {
        return WLMixtape.sortedFetchRequest(forCollectionID: collection.id)
    }
    
    public class func sortedFetchRequest(forCollectionID collectionID: Int32) -> NSFetchRequest<WLMixtape> {
        let fetchRequest: NSFetchRequest<WLMixtape> = WLMixtape.fetchRequest()
        let releasedSort = NSSortDescriptor(key: "released", ascending: false)
        fetchRequest.sortDescriptors = [releasedSort]
        let predicate = NSPredicate(format: "collectionID == \(collectionID)")
        fetchRequest.predicate = predicate
        return fetchRequest
    }
    
    // MARK: Mixtape removal
    
    public class func deleteMixtapes() {
        CoreDataStack.deleteEntity(name: WLMixtape.entityName)
    }
    
    public class func deleteMixtapes(forCollection collection: WLCollection) {
        WLMixtape.deleteMixtapes(forCollectionID: collection.id)
    }
    
    public class func deleteMixtapes(forCollectionID collectionID: Int32) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: WLMixtape.entityName)
        let predicate = NSPredicate(format: "collectionID == \(collectionID)")
        fetchRequest.predicate = predicate
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        let context = CoreDataStack.shared.backgroundManagedObjectContext
        do {
            let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
            if let objectIDArray = result?.result as? [NSManagedObjectID] {
                let changes = [NSDeletedObjectsKey : objectIDArray]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
            }
        } catch let error as NSError {
            print("Unable to delete mixtapes: \(error.userInfo)")
        }
    }
    
    // MARK: ResponseObjectSerializable

    convenience init?(response: HTTPURLResponse, representation: Any) {
        let context = CoreDataStack.shared.backgroundManagedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: WLMixtape.entityName, in: context)!
        self.init(entity: entity, insertInto: context)
        
        if !setupWithRespresentation(representation) {
            return nil
        }
    }
    
    func updateInstanceWith(response: HTTPURLResponse, representation: Any) {
        setupWithRespresentation(representation)
    }
    
    static func existingInstance(response: HTTPURLResponse, representation: Any) -> Self? {
        return existingInstanceHelper(response: response, representation: representation)
    }
    
    // Helper function, as per https://stackoverflow.com/a/33200426
    private static func existingInstanceHelper<T>(response: HTTPURLResponse, representation: Any) -> T? {
        guard
            let representation = representation as? [String: Any],
            let id = representation["id"] as? Int32,
            let existingMixtape = WLMixtape.mixtape(forID: id) as? T
        else {
            return nil
        }
        return existingMixtape
    }
    
    // MARK: Utility
    
    @discardableResult
    fileprivate func setupWithRespresentation(_ representation: Any) -> Bool {
        
        guard
            let representation = representation as? [String: Any],
            let id = representation["id"] as? Int32,
            let slug = representation["slug"] as? String,
            let title = representation["title"] as? String,
            let createdDateString = representation["created"] as? String,
            let created = Date.date(from: createdDateString),
            let modifiedDateString = representation["modified"] as? String,
            let modified = Date.date(from: modifiedDateString),
            let collectionID = representation["collection"] as? Int32
        else {
            return false
        }
        
        self.id = id
        self.slug = slug
        self.title = title
        self.created = created as NSDate
        self.modified = modified as NSDate
        self.collectionID = collectionID
        
        descriptionText = representation["description"] as? String
        artworkURL = representation["artwork_url"] as? String
        artworkCredit = representation["artwork_credit"] as? String
        artworkCreditURL = representation["artwork_credit_url"] as? String
        sponsor = representation["sponsor"] as? String
        sponsorURL = representation["sponsor_url"] as? String
        product = representation["product"] as? String
        productURL = representation["product_url"] as? String
        
        if
            let releasedDateString = representation["release"] as? String,
            let released = Date.date(from: releasedDateString)
        {
            self.released = released as NSDate
        }
        
        if let trackCount = representation["track_count"] as? Int32 {
            self.trackCount = trackCount
        }
        
        return true
    }
    
}
