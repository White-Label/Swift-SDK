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


public func GetLabel(complete: @escaping (WLLabel?, Error?) -> Void) {
    Alamofire.request(Router.getLabel).validate().responseObject { (response: DataResponse<WLLabel>) in
        complete(response.result.value, response.result.error)
    }
}

public func ListCollections(parameters: Parameters? = nil, page: UInt = 1, complete: @escaping ([WLCollection]?) -> Void) {
    
    var params = parameters ?? Parameters()
    params["page"] = page
    
    Alamofire.request(Router.listCollections(parameters: params)).validate().responseCollection { (response: DataResponse<[WLCollection]>) in
        
        if let count = (response.response?.allHeaderFields["Count"] as? NSString)?.integerValue {
            print("\(count) collections")
        }
        
        complete(response.result.value)
    }
}

public func GetCollection(_ id: Any, complete: @escaping (WLCollection?) -> Void) {
    
    var identifier = id
    if let collection = id as? WLCollection {
        identifier = collection.id
    }
    
    Alamofire.request(Router.getCollection(id: identifier)).validate().responseObject { (response: DataResponse<WLCollection>) in
        complete(response.result.value)
    }
}

public func ListMixtapesInCollection(_ collection: WLCollection, parameters: Parameters? = nil, page: UInt = 1, complete: @escaping (_ total: NSNumber?, _ mixtapes: [WLMixtape]?) -> Void) {
    
    var params = parameters ?? Parameters()
    params["collection"] = collection.id
    
    WhiteLabel.ListMixtapes(parameters: params, page: page, complete: complete)
}

public func ListMixtapes(parameters: Parameters? = nil, page: UInt = 1, complete: @escaping (_ total: NSNumber?, _ mixtapes: [WLMixtape]?) -> Void) {
    
    var params = parameters ?? Parameters()
    params["page"] = page
    
    Alamofire.request(Router.listMixtapes(parameters: params)).validate().responseCollection { (response: DataResponse<[WLMixtape]>) in
        if let count = (response.response?.allHeaderFields["Count"] as? NSString)?.integerValue {
            print("\(count) mixtapes")
        }
        complete(0, response.result.value)
    }
}

public func GetMixtape(_ id: Any, complete: @escaping (WLMixtape?) -> Void) {
    
    var identifier = id
    if let mixtape = id as? WLMixtape {
        identifier = mixtape.id
    }
    
    Alamofire.request(Router.getMixtape(id: identifier)).validate().responseObject { (response: DataResponse<WLMixtape>) in
        complete(response.result.value)
    }
}

public func ListTracksInMixtape(_ mixtape: WLMixtape, parameters: Parameters? = nil, page: UInt = 1, complete: @escaping ([WLTrack]?) -> Void) {
    
    var params = parameters ?? Parameters()
    params["mixtape"] = mixtape.id
    
    WhiteLabel.ListTracks(parameters: params, page: page, complete: complete)
}

public func ListTracks(parameters: Parameters? = nil, page: UInt = 1, complete: @escaping ([WLTrack]?) -> Void) {
    
    var params = parameters ?? Parameters()
    params["page"] = page
    
    Alamofire.request(Router.listTracks(parameters: params)).validate().responseCollection { (response: DataResponse<[WLTrack]>) in
        if let count = (response.response?.allHeaderFields["Count"] as? NSString)?.integerValue {
            print("\(count) tracks")
        }
        complete(response.result.value)
    }
}

public func GetTrack(_ id: Any, complete: @escaping (WLTrack?) -> Void) {
    
    var identifier = id
    if let track = id as? WLTrack {
        identifier = track.id
    }
    
    Alamofire.request(Router.getTrack(id: identifier)).validate().responseObject { (response: DataResponse<WLTrack>) in
        complete(response.result.value)
    }
}
