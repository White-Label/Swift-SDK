//
//  WLMixtape.swift
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


public struct WLMixtape: ResponseObjectSerializable, ResponseCollectionSerializable {
    
    public var id : Int!
    public var title : String!
    public var slug : String!
    public var description : String?
    public var artworkURL : URL?
    public var artworkCredit : String?
    public var artworkCreditURL : URL?
    public var sponsor : String?
    public var sponsorURL : URL?
    public var product : String?
    public var productURL : URL?
    public var createdDate : Date!
    public var releaseDate : Date?
    public var trackCount : Int!
    public var collectionID : Int!
    
    public init?(response: HTTPURLResponse, representation: Any) {
        
        guard let representation = representation as? [String: Any] else {
            return nil
        }
        
        id = representation["id"] as! Int
        title = representation["title"] as! String
        slug = representation["slug"] as! String
        description = representation["description"] as? String
        if let artworkURLString = representation["artwork_url"] as? String {
            artworkURL = URL(string: artworkURLString)
        }
        artworkCredit = representation["artwork_credit"] as? String
        if let artworkCreditURLString = representation["artwork_credit_url"] as? String {
            artworkCreditURL = URL(string: artworkCreditURLString)
        }
        sponsor = representation["sponsor"] as? String
        if let sponsorURLString = representation["sponsor_url"] as? String {
            sponsorURL = URL(string: sponsorURLString)
        }
        product = representation["product"] as? String
        if let productURLString = representation["product_url"] as? String {
            productURL = URL(string: productURLString)
        }
        let createdDateString = representation["created"] as! String
        createdDate = Date(string: createdDateString)
        if let releaseDateString = representation["realease"] as? String {
            releaseDate = Date(string: releaseDateString)
        }
        trackCount = representation["track_count"] as! Int
        collectionID = representation["collection"] as! Int
    }
    
}
