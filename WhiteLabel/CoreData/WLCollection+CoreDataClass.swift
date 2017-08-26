//
//  WLCollection+CoreDataClass.swift
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

@objc(WLCollection)
final public class WLCollection: NSManagedObject, ResponseObjectSerializable, ResponseCollectionSerializable {
    
    public static let entityName = "WLCollection"
    
    public var mixtapes: [WLMixtape]? {
        return WLMixtape.mixtapes(forCollection: self)
    }
    
    public var tracks: [WLTrack]? {
        guard let mixtapes = self.mixtapes else { return nil }
        var collectionTracks = [WLTrack]()
        for mixtape in mixtapes {
            if let mixtapeTracks = mixtape.tracks {
                collectionTracks.append(contentsOf: mixtapeTracks)
            }
        }
        if collectionTracks.count == 0 {
            return nil
        }
        return collectionTracks
    }
    
    // MARK: Collection retrieval
    
    public class func collection(forID id: Int32) -> WLCollection? {
        let context = CoreDataStack.shared.backgroundManagedObjectContext
        let fetchRequest: NSFetchRequest<WLCollection> = WLCollection.fetchRequest()
        let predicate = NSPredicate(format: "id == \(id)")
        fetchRequest.predicate = predicate
        do {
            let collection = try context.fetch(fetchRequest).first
            return collection
        } catch let error as NSError {
            print("Unable to retrieve collection for id \(id): \(error.userInfo)")
            return nil
        }
    }
    
    public class func collections() -> [WLCollection]? {
        let fetchRequest =  WLCollection.sortedFetchRequest()
        let context = CoreDataStack.shared.backgroundManagedObjectContext
        do {
            let collections = try context.fetch(fetchRequest)
            return collections
        } catch let error as NSError {
            print("Unable to get collections: \(error.userInfo)")
            return nil
        }
    }
    
    public class func sortedFetchRequest() -> NSFetchRequest<WLCollection> {
        let fetchRequest: NSFetchRequest<WLCollection> = WLCollection.fetchRequest()
        let createdSort = NSSortDescriptor(key: "created", ascending: true)
        fetchRequest.sortDescriptors = [createdSort]
        return fetchRequest
    }
    
    // MARK: Collection removal
    
    public class func deleteCollections() {
        CoreDataStack.deleteEntity(name: WLCollection.entityName)
    }
    
    // MARK: ResponseObjectSerializable
    
    convenience init?(response: HTTPURLResponse, representation: Any) {
        let context = CoreDataStack.shared.backgroundManagedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: WLCollection.entityName, in: context)!
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
    fileprivate static func existingInstanceHelper<T>(response: HTTPURLResponse, representation: Any) -> T? {
        guard
            let representation = representation as? [String: Any],
            let id = representation["id"] as? Int32,
            let existingCollection = WLCollection.collection(forID: id) as? T
        else {
            return nil
        }
        return existingCollection
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
            let modified = Date.date(from: modifiedDateString)
        else {
            return false
        }
        
        self.id = id
        self.slug = slug
        self.title = title
        self.created = created as NSDate
        self.modified = modified as NSDate
        
        descriptionText = representation["description"] as? String
        artworkURL = representation["artwork_url"] as? String
        artworkCredit = representation["artwork_credit"] as? String
        artworkCreditURL = representation["artwork_credit_url"] as? String
        
        if let mixtapeCount = representation["mixtape_count"] as? Int32 {
            self.mixtapeCount = mixtapeCount
        }
        
        return true
    }
    
}
