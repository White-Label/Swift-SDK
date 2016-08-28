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


import Alamofire

public final class Collection: ResponseObjectSerializable, ResponseCollectionSerializable {
    
    public var id : NSNumber!
    public var title : String!
    public var slug : String!
    public var descriptionText : String?
    public var artworkURL : String?
    public var artworkCredit : String?
    public var artworkCreditURL : String?
    public var createdDate : String?
    public var mixtapeCount : NSNumber!
    
    public required init?(response: NSHTTPURLResponse, representation: AnyObject) {
        
        id = representation.valueForKeyPath("id") as! NSNumber
        title = representation.valueForKeyPath("title") as! String
        slug = representation.valueForKeyPath("slug") as! String
        descriptionText = representation.valueForKeyPath("description") as? String
        artworkURL = representation.valueForKeyPath("artwork_url") as? String
        artworkCredit = representation.valueForKeyPath("artwork_credit") as? String
        artworkCreditURL = representation.valueForKeyPath("artwork_credit_url") as? String
        createdDate = representation.valueForKeyPath("created") as! String
        mixtapeCount = representation.valueForKeyPath("mixtape_count") as! NSNumber
        
    }
}
