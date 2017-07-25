//
//  WLTrack+CoreDataProperties.swift
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
