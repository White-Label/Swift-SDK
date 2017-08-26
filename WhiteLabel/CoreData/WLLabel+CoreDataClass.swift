//
//  WLLabel+CoreDataClass.swift
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

@objc(WLLabel)
final public class WLLabel: NSManagedObject, ResponseObjectSerializable, ResponseCollectionSerializable {
    
    public static let entityName = "WLLabel"
    
    convenience init?(response: HTTPURLResponse, representation: Any) {
        
        let context = CoreDataStack.shared.backgroundManagedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: WLLabel.entityName, in: context)!
        self.init(entity: entity, insertInto: context)
        
        guard
            let representation = representation as? [String: Any],
            let id = representation["id"] as? Int32,
            let slug = representation["slug"] as? String,
            let name = representation["name"] as? String
//            let serviceRepresentation = representation["service"]
        else {
            return nil
        }
        
        self.id = id
        self.slug = slug
        self.name = name
        
        iconURL = representation["icon"] as? String
        
//        self.service = WLService(response: response, representation: serviceRepresentation)
    }
    
    func updateInstanceWith(response: HTTPURLResponse, representation: Any) {
        
    }
    
    static func existingInstance(response: HTTPURLResponse, representation: Any) -> Self? {
        return nil
    }
    
}
