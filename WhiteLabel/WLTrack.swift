//
//  WLTrack.swift
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


public struct WLTrack: ResponseObjectSerializable, ResponseCollectionSerializable, Equatable {
    
    public var id : Int!
    public var title : String!
    public var artist : String!
    public var slug : String!
    public var streamable : Bool!
    public var duration : Int?
    public var externalID : Int!
    public var streamURL : URL!
    public var permalinkURL : URL?
    public var artworkURL : URL?
    public var purchaseURL : URL?
    public var downloadURL : URL?
    public var ticketURL : URL?
    public var playCount : Int!
    public var order : Int!
    public var mixtapeID: Int!
    
    public init?(response: HTTPURLResponse, representation: Any) {
        
        guard let representation = representation as? [String: Any] else {
            return nil
        }
        
        id = representation["id"] as! Int
        title = representation["title"] as! String
        artist = representation["artist"] as! String
        slug = representation["slug"] as! String
        streamable = representation["streamable"] as! Bool
        duration = representation["duration"] as? Int
        externalID = representation["external_id"] as! Int
        let streamURLString = representation["stream_url"] as! String
        streamURL = URL(string: streamURLString)
        if let permalinkURLString = representation["permalink_url"] as? String {
            permalinkURL = URL(string: permalinkURLString)
        }
        if let artworkURLString = representation["artwork_url"] as? String {
            artworkURL = URL(string: artworkURLString)
        }
        if let purchaseURLString = representation["purchase_url"] as? String {
            purchaseURL = URL(string: purchaseURLString)
        }
        if let downloadURLString = representation["download_url"] as? String {
            downloadURL = URL(string: downloadURLString)
        }
        playCount = representation["play_count"] as! Int
        order = representation["order"] as! Int
        mixtapeID = representation["mixtape"] as! Int
    }
    
}

func ==(lhs: WLTrack, rhs: WLTrack) -> Bool {
    return lhs.id == rhs.id
}
