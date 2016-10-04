//
//  Track.swift
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


public struct Track: ResponseObjectSerializable, ResponseCollectionSerializable {
    
    public var id : NSNumber!
    public var title : String!
    public var artist : String!
    public var slug : String!
    public var streamable : Bool!
    public var duration : NSNumber?
    public var externalID : NSNumber!
    public var streamURL : String!
    public var permalinkURL : String?
    public var artworkURL : String?
    public var purchaseURL : String?
    public var downloadURL : String?
    public var ticketURL : String?
    public var playCount : NSNumber!
    public var order : NSNumber!
    
    public init?(response: HTTPURLResponse, representation: Any) {
        
        guard let representation = representation as? [String: Any] else {
            return nil
        }
        
        id = representation["id"] as! NSNumber
        title = representation["title"] as! String
        artist = representation["artist"] as! String
        slug = representation["slug"] as! String
        streamable = representation["streamable"] as! Bool
        duration = representation["duration"] as? NSNumber
        externalID = representation["external_id"] as! NSNumber
        streamURL = representation["stream_url"] as! String
        permalinkURL = representation["permalink_url"] as? String
        artworkURL = representation["artwork_url"] as? String
        purchaseURL = representation["purchase_url"] as? String
        downloadURL = representation["download_url"] as? String
        playCount = representation["play_count"] as! NSNumber
        order = representation["order"] as! NSNumber
        
    }
    
}
