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

open class WhiteLabel {
    
    open static let BaseURLString: String = "https://beta.whitelabel.cool/api"
    open static var Version: String = "1.0"
    open static let ErrorDomain: String = "cool.whitelabel.swift"
    open static var PageSize: UInt = 20
    open static var ClientID: String?
    
    open class func GetLabel(success: @escaping ((Label!) -> Void), failure: @escaping ((BackendError!) -> Void)) {
        
        Alamofire.request(Router.GetLabel).validate()
            .responseObject { (response: Response<Label, BackendError>) in
                switch response.result {
                case .Success(let label):
                    success(label)
                case .Failure(let error):
                    failure(error)
                }
        }
    }
    
    open class func ListCollections(parameters: [String: AnyObject]?, page: UInt, success: @escaping (([Collection]!) -> Void), failure: @escaping ((BackendError!) -> Void)) {
        
        var params = parameters != nil ? parameters! : [String: AnyObject]()
        params["page"] = String(page) as AnyObject?
        
        Alamofire.request(Router.ListCollections(parameters: params)).validate()
            .responseCollection { (response: Response<[Collection], BackendError>) in
                switch response.result {
                case .Success(let collections):
                    success(collections)
                case .Failure(let error):
                    failure(error)
                }
        }
    }
    
    open class func GetCollection(_ id: AnyObject, success: @escaping ((Collection!) -> Void), failure: @escaping ((BackendError!) -> Void)) {
        
        var identifier = id
        
        if let collection = id as? Collection {
            identifier = collection.id
        }
        
        Alamofire.request(Router.GetCollection(id: identifier)).validate()
            .responseObject { (response: Response<Collection, BackendError>) in
                switch response.result {
                case .Success(let collection):
                    success(collection)
                case .Failure(let error):
                    failure(error)
                }
        }
    }
    
    open class func ListMixtapesForCollection(_ collection: Collection, page: UInt, success: @escaping (([Mixtape]!) -> Void), failure: @escaping ((BackendError!) -> Void)) {
        
        var parameters = [String: AnyObject]()
        parameters["collection"] = String(collection.id)
        
        WhiteLabel.ListMixtapes(parameters: parameters, page: page, success: success, failure: failure)
    }
    
    open class func ListMixtapes(parameters: [String: AnyObject]?, page: UInt, success: @escaping (([Mixtape]!) -> Void), failure: @escaping ((BackendError!) -> Void)) {
        
        var params = parameters != nil ? parameters! : [String: AnyObject]()
        params["page"] = String(page) as AnyObject?
        
        Alamofire.request(Router.ListMixtapes(parameters: params)).validate()
            .responseCollection { (response: Response<[Mixtape], BackendError>) in
                switch response.result {
                case .Success(let mixtapes):
                    success(mixtapes)
                case .Failure(let error):
                    failure(error)
                }
        }
    }
    
    open class func GetMixtape(_ id: AnyObject, success: @escaping ((Mixtape!) -> Void), failure: @escaping ((BackendError!) -> Void)) {
        
        var identifier = id
        
        if let mixtape = id as? Mixtape {
            identifier = mixtape.id
        }
        
        Alamofire.request(Router.GetMixtape(id: identifier)).validate()
            .responseObject { (response: Response<Mixtape, BackendError>) in
                switch response.result {
                case .Success(let mixtape):
                    success(mixtape)
                case .Failure(let error):
                    failure(error)
                }
        }
    }
    
    open class func ListTracksForMixtape(_ mixtape: Mixtape, page: UInt, success: @escaping (([Track]!) -> Void), failure: @escaping ((BackendError!) -> Void)) {
        
        var parameters = [String: AnyObject]()
        parameters["mixtape"] = String(mixtape.id)
        
        WhiteLabel.ListTracks(parameters: parameters, page: page, success: success, failure: failure)
    }
    
    open class func ListTracks(parameters: [String: AnyObject]?, page: UInt, success: @escaping (([Track]!) -> Void), failure: @escaping ((BackendError!) -> Void)) {
        
        var params = parameters != nil ? parameters! : [String: AnyObject]()
        params["page"] = String(page) as AnyObject?
        
        Alamofire.request(Router.ListTracks(parameters: params)).validate()
            .responseCollection { (response: Response<[Track], BackendError>) in
                switch response.result {
                case .Success(let tracks):
                    success(tracks)
                case .Failure(let error):
                    failure(error)
                }
        }
    }
    
    open class func GetTrack(_ id: AnyObject, success: @escaping ((Track!) -> Void), failure: @escaping ((BackendError!) -> Void)) {
        
        var identifier = id
        
        if let track = id as? Track {
            identifier = track.id
        }
        
        Alamofire.request(Router.GetTrack(id: identifier)).validate()
            .responseObject { (response: Response<Track, BackendError>) in
                switch response.result {
                case .Success(let track):
                    success(track)
                case .Failure(let error):
                    failure(error)
                }
        }
    }
}
