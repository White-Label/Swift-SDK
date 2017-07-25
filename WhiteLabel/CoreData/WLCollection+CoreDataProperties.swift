//
//  WLCollection+CoreDataProperties.swift
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


extension WLCollection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WLCollection> {
        return NSFetchRequest<WLCollection>(entityName: "WLCollection")
    }

    @NSManaged public var artworkCredit: String?
    @NSManaged public var artworkCreditURL: String?
    @NSManaged public var artworkURL: String?
    @NSManaged public var created: NSDate?
    @NSManaged public var descriptionText: String?
    @NSManaged public var id: Int32
    @NSManaged public var mixtapeCount: Int32
    @NSManaged public var modified: NSDate?
    @NSManaged public var slug: String?
    @NSManaged public var title: String?
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
