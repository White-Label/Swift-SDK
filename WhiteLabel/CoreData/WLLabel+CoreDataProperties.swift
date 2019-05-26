//
//  WLLabel+CoreDataProperties.swift
//  Pods
//
//  Created by Alexander Givens on 8/6/17.
//
//

import Foundation
import CoreData


extension WLLabel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WLLabel> {
        return NSFetchRequest<WLLabel>(entityName: "WLLabel")
    }

    @NSManaged public var iconURL: String?
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var slug: String?

}
