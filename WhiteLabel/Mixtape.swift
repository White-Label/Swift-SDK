//
//  Mixtape.swift
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

public final class Mixtape: ResponseObjectSerializable, ResponseCollectionSerializable {
    
    public var id : NSNumber!
    public var title : String!
    public var slug : String!
    public var descriptionText : String?
    public var artworkURL : String?
    public var artworkCredit : String?
    public var artworkCreditURL : String?
    public var sponsor : String?
    public var sponsorURL : String?
    public var product : String?
    public var productURL : String?
    public var releaseDate : String?
    public var trackCount : NSNumber!
    public var collectionID : NSNumber!
    
    public required init?(response: HTTPURLResponse, representation: AnyObject) {
        
        id = representation.value(forKeyPath: "id") as! NSNumber
        title = representation.value(forKeyPath: "title") as! String
        slug = representation.value(forKeyPath: "slug") as! String
        descriptionText = representation.value(forKeyPath: "description") as? String
        artworkURL = representation.value(forKeyPath: "artwork_url") as? String
        artworkCredit = representation.value(forKeyPath: "artwork_credit") as? String
        artworkCreditURL = representation.value(forKeyPath: "artwork_credit_url") as? String
        sponsor = representation.value(forKeyPath: "sponsor") as? String
        sponsorURL = representation.value(forKeyPath: "sponsor_url") as? String
        product = representation.value(forKeyPath: "product") as? String
        productURL = representation.value(forKeyPath: "product_url") as? String
        releaseDate = representation.value(forKeyPath: "realease") as? String
        trackCount = representation.value(forKeyPath: "track_count") as! NSNumber
        collectionID = representation.value(forKeyPath: "collection") as! NSNumber
        
    }
}
