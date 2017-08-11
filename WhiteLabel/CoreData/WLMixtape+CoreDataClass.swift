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
    
    public var collection: WLCollection? {
        let context = CoreDataStack.sharedStack.managedObjectContext
        let fetchRequest: NSFetchRequest<WLCollection> = WLCollection.fetchRequest()
        let predicate = NSPredicate(format: "id == \(self.collectionID)")
        fetchRequest.predicate = predicate
        do {
            let collections = try context.fetch(fetchRequest)
            return collections.first
        } catch let error as NSError {
            print("Unable to retrieve collection: \(error.userInfo)")
            return nil
        }
    }
    
    public var tracks: [WLTrack]? {
        let context = CoreDataStack.sharedStack.managedObjectContext
        let fetchRequest: NSFetchRequest<WLTrack> = WLTrack.fetchRequest()
        let predicate = NSPredicate(format: "mixtapeID == \(self.id)")
        fetchRequest.predicate = predicate
        do {
            let tracks = try context.fetch(fetchRequest)
            return tracks
        } catch let error as NSError {
            print("Unable to retrieve tracks: \(error.userInfo)")
            return nil
        }
    }

    convenience init?(response: HTTPURLResponse, representation: Any) {
        
        let context = CoreDataStack.sharedStack.managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "WLMixtape", in: context)!
        self.init(entity: entity, insertInto: context)
        
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
            return nil
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
        
    }
    
    // Helper function, as per https://stackoverflow.com/a/33200426
    static func existingInstance(response: HTTPURLResponse, representation: Any) -> Self? {
        return existingInstanceHelper(response: response, representation: representation)
    }
    
    private static func existingInstanceHelper<T>(response: HTTPURLResponse, representation: Any) -> T? {
        
        guard
            let representation = representation as? [String: Any],
            let id = representation["id"] as? Int32,
            let modifiedDateString = representation["modified"] as? String,
            let modified = Date.date(from: modifiedDateString)
            else {
                return nil
        }
        
        let moc = CoreDataStack.sharedStack.managedObjectContext
        let fetchRequest: NSFetchRequest<WLMixtape> = WLMixtape.fetchRequest()
        let predicate = NSPredicate(format: "id == \(id)")
        fetchRequest.predicate = predicate
        
        do {
            let mixtapes = try moc.fetch(fetchRequest)
            if
                let mixtape = mixtapes.first,
                let cachedModified = mixtape.modified,
                (cachedModified as Date) >= modified
            {
                return mixtape as? T
            }
        } catch let error as NSError {
            print("Unable to retrieve mixtapes: \(error.userInfo)")
        }
        
        return nil
    }
    
    public class func deleteCache() {
        CoreDataStack.deleteEntity(name: "WLMixtape")
    }
    
}
