//
//  WLTrack+CoreDataProperties.swift
//  Pods
//
//  Created by Alexander Givens on 7/21/17.
//
//

import Foundation
import CoreData


extension WLTrack {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WLTrack> {
        return NSFetchRequest<WLTrack>(entityName: "WLTrack")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var artist: String?
    @NSManaged public var slug: String?
    @NSManaged public var streamable: Bool
    @NSManaged public var duration: Int32
    @NSManaged public var externalID: String?
    @NSManaged public var streamURL: String?
    @NSManaged public var permalinkURL: String?
    @NSManaged public var artworkURL: String?
    @NSManaged public var purchaseURL: String?
    @NSManaged public var downloadURL: String?
    @NSManaged public var ticketURL: String?
    @NSManaged public var playCount: Int32
    @NSManaged public var order: Int32
    @NSManaged public var created: NSDate?
    @NSManaged public var modified: NSDate?
    @NSManaged public var mixtape: WLMixtape?

}
