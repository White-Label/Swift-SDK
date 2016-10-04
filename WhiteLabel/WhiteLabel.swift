//
//  WhiteLabel.swift
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


import Foundation
import Alamofire


public func GetLabel(complete: @escaping (Label?) -> Void) {
    Alamofire.request(Router.getLabel).validate().responseObject { (response: DataResponse<Label>) in
        complete(response.result.value)
    }
}

public func ListCollections(page: UInt = 1, parameters: Parameters?, complete: @escaping ([WhiteLabel.Collection]?) -> Void) {
    
    var params = parameters ?? Parameters()
    params["page"] = page
    
    Alamofire.request(Router.listCollections(parameters: params)).validate().responseCollection { (response: DataResponse<[WhiteLabel.Collection]>) in
        complete(response.result.value)
    }
}

public func GetCollection(_ id: AnyObject, complete: @escaping (WhiteLabel.Collection?) -> Void) {
    
    var identifier = id
    if let collection = id as? WhiteLabel.Collection {
        identifier = collection.id
    }
    
    Alamofire.request(Router.getCollection(id: identifier)).validate().responseObject { (response: DataResponse<WhiteLabel.Collection>) in
        complete(response.result.value)
    }
}

public func ListMixtapesInCollection(_ collection: WhiteLabel.Collection, page: UInt = 1, complete: @escaping ([Mixtape]?) -> Void) {
    
    let parameters: Parameters = [
        "collection": collection.id
    ]
    
    WhiteLabel.ListMixtapes(page: page, parameters: parameters, complete: complete)
}

public func ListMixtapes(page: UInt = 1, parameters: Parameters?, complete: @escaping ([Mixtape]?) -> Void) {
    
    var params = parameters ?? Parameters()
    params["page"] = page
    
    Alamofire.request(Router.listMixtapes(parameters: params)).validate().responseCollection { (response: DataResponse<[Mixtape]>) in
        complete(response.result.value)
    }
}

public func GetMixtape(_ id: AnyObject, complete: @escaping (Mixtape?) -> Void) {
    
    var identifier = id
    if let mixtape = id as? Mixtape {
        identifier = mixtape.id
    }
    
    Alamofire.request(Router.getMixtape(id: identifier)).validate().responseObject { (response: DataResponse<Mixtape>) in
        complete(response.result.value)
    }
}

public func ListTracksInMixtape(_ mixtape: Mixtape, page: UInt = 1, complete: @escaping ([Track]?) -> Void) {
    
    let parameters: Parameters = [
        "mixtape": mixtape.id
    ]
    
    WhiteLabel.ListTracks(page: page, parameters: parameters, complete: complete)
}

public func ListTracks(page: UInt, parameters: Parameters?, complete: @escaping ([Track]?) -> Void) {
    
    var params = parameters ?? Parameters()
    params["page"] = page
    
    Alamofire.request(Router.listTracks(parameters: params)).validate().responseCollection { (response: DataResponse<[Track]>) in
        complete(response.result.value)
    }
}

public func GetTrack(_ id: AnyObject, complete: @escaping (Track?) -> Void) {
    
    var identifier = id
    if let track = id as? Track {
        identifier = track.id
    }
    
    Alamofire.request(Router.getTrack(id: identifier)).validate().responseObject { (response: DataResponse<Track>) in
        complete(response.result.value)
    }
}
