//
//  Collection.swift
//
//  Created by Alex Givens http://alexgivens.com on 1/13/16
//  Copyright © 2016 Noon Pacific LLC http://noonpacific.com
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

import SwiftyJSON

public class Collection: Equatable {
    
    public var id : Int!
    public var title : String!
    public var slug : String!
    public var description : String?
    public var artworkURL : String?
    public var artworkCredit : String?
    public var artworkCreditURL : String?
    public var mixtapeCount : Int!
    public var mixtapes: [Mixtape]? = nil
    
    public init(fromJson json: JSON!) {
        
        if json == nil || json.count == 0 { return }
        
        id = json["id"].intValue
        title = json["title"].stringValue
        slug = json["slug"].stringValue
        description = json["description"].stringValue
        artworkURL = json["artwork_url"].stringValue
        artworkCredit = json["artwork_credit"].stringValue
        artworkCreditURL = json["artwork_credit_url"].stringValue
        mixtapeCount = json["mixtape_count"].intValue
    }
    
    public struct Request {
        
        public var order : [Order]?
        public var search : String?
        
        public enum Order: String {
            case id
            case title
            case created
        }
        
        public init()  {
            var query = "?search=" + search
            
            if order.count > 0 {
                
                query += "&order="
                
                for item in order {
                    query += "\(item),"
                }
            }
        }
    }
}

public func ==(lhs: Collection, rhs: Collection) -> Bool {
    return lhs.id == rhs.id
}
