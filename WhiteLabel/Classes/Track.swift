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

import SwiftyJSON

public class Track: Equatable {
    
    public var artistName : String!
    public var title : String!
    public var id : Int!
    public var soundCloudID : Int!
    public var soundCloudStreamURL : String!
    public var soundCloudPermalink : String!
    public var sourceNotFound : Bool!
    public var trackID : Int!
    public var number : Int!
    
    public init(fromJson json: JSON!, withSoundCloudToken soundCloudToken: String!){
        if json == nil {return }
        
        artistName = json["artist_description"].stringValue
        title = json["title"].stringValue
        id = json["id"].intValue
        soundCloudID = json["soundcloud_id"].intValue
        soundCloudStreamURL = json["soundcloud_stream_url"].stringValue + "?client_id=" + soundCloudToken
        soundCloudPermalink = json["soundcloud_permalink_url"].stringValue
        sourceNotFound = json["source_not_found"].boolValue
        trackID = json["track_id"].intValue
        number = json["track_number"].intValue
    }
}

public func ==(lhs: Track, rhs: Track) -> Bool {
    return lhs.id == rhs.id
}