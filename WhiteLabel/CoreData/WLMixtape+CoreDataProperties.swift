//
//  WLMixtape+CoreDataProperties.swift
//  Pods
//
//  Created by Alexander Givens on 8/6/17.
//
//

import Foundation
import CoreData


extension WLMixtape {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WLMixtape> {
        return NSFetchRequest<WLMixtape>(entityName: "WLMixtape")
    }

    @NSManaged public var artworkCredit: String?
    @NSManaged public var artworkCreditURL: String?
    @NSManaged public var artworkURL: String?
    @NSManaged public var created: NSDate?
    @NSManaged public var descriptionText: String?
    @NSManaged public var id: Int32
    @NSManaged public var modified: NSDate?
    @NSManaged public var product: String?
    @NSManaged public var productURL: String?
    @NSManaged public var released: NSDate?
    @NSManaged public var slug: String?
    @NSManaged public var sponsor: String?
    @NSManaged public var sponsorURL: String?
    @NSManaged public var title: String?
    @NSManaged public var trackCount: Int32
    @NSManaged public var collectionID: Int32

}
