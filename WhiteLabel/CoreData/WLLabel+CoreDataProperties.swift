//
//  WLLabel+CoreDataProperties.swift
//  Pods
//
//  Created by Alexander Givens on 7/21/17.
//
//

import Foundation
import CoreData


extension WLLabel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WLLabel> {
        return NSFetchRequest<WLLabel>(entityName: "WLLabel")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var slug: String?
    @NSManaged public var iconURL: String?
    @NSManaged public var collections: NSSet?
    @NSManaged public var service: WLService?

}

// MARK: Generated accessors for collections
extension WLLabel {

    @objc(addCollectionsObject:)
    @NSManaged public func addToCollections(_ value: WLCollection)

    @objc(removeCollectionsObject:)
    @NSManaged public func removeFromCollections(_ value: WLCollection)

    @objc(addCollections:)
    @NSManaged public func addToCollections(_ values: NSSet)

    @objc(removeCollections:)
    @NSManaged public func removeFromCollections(_ values: NSSet)

}
