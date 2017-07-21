//
//  WLCollection+CoreDataProperties.swift
//  Pods
//
//  Created by Alexander Givens on 7/21/17.
//
//

import Foundation
import CoreData


extension WLCollection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WLCollection> {
        return NSFetchRequest<WLCollection>(entityName: "WLCollection")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var slug: String?
    @NSManaged public var artworkURL: String?
    @NSManaged public var artworkCredit: String?
    @NSManaged public var artworkCreditURL: String?
    @NSManaged public var created: NSDate?
    @NSManaged public var mixtapeCount: Int32
    @NSManaged public var modified: NSDate?
    @NSManaged public var descriptionText: String?
    @NSManaged public var label: WLLabel?
    @NSManaged public var mixtapes: NSSet?

}

// MARK: Generated accessors for mixtapes
extension WLCollection {

    @objc(addMixtapesObject:)
    @NSManaged public func addToMixtapes(_ value: WLMixtape)

    @objc(removeMixtapesObject:)
    @NSManaged public func removeFromMixtapes(_ value: WLMixtape)

    @objc(addMixtapes:)
    @NSManaged public func addToMixtapes(_ values: NSSet)

    @objc(removeMixtapes:)
    @NSManaged public func removeFromMixtapes(_ values: NSSet)

}
