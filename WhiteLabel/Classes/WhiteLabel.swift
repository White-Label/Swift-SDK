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

public class WhiteLabel {
    
    public static let BaseURLString: String = "https://beta.whitelabel.cool/api"
    public static var Version: String = "1.0"
    public static let ErrorDomain: String = "cool.whitelabel.swift"
    public static var PageSize: UInt = 20
    public static var ClientID: String?
    
    public class func GetLabel(success success: (Label! -> Void), failure: (BackendError! -> Void)) {
        
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
    
    public class func ListCollections(parameters parameters: [String: AnyObject]?, page: UInt, success: ([Collection]! -> Void), failure: (BackendError! -> Void)) {
        
        var params = parameters != nil ? parameters! : [String: AnyObject]()
        params["page"] = String(page)
        
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
    
    public class func GetCollection(id: AnyObject, success: (Collection! -> Void), failure: (BackendError! -> Void)) {
        
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
    
    public class func ListMixtapesForCollection(collection: Collection, page: UInt, success: ([Mixtape]! -> Void), failure: (BackendError! -> Void)) {
        
        var parameters = [String: AnyObject]()
        parameters["collection"] = String(collection.id)
        
        WhiteLabel.ListMixtapes(parameters: parameters, page: page, success: success, failure: failure)
    }
    
    public class func ListMixtapes(parameters parameters: [String: AnyObject]?, page: UInt, success: ([Mixtape]! -> Void), failure: (BackendError! -> Void)) {
        
        var params = parameters != nil ? parameters! : [String: AnyObject]()
        params["page"] = String(page)
        
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
    
    public class func GetMixtape(id: AnyObject, success: (Mixtape! -> Void), failure: (BackendError! -> Void)) {
        
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
    
    public class func ListTracksForMixtape(mixtape: Mixtape, page: UInt, success: ([Track]! -> Void), failure: (BackendError! -> Void)) {
        
        var parameters = [String: AnyObject]()
        parameters["mixtape"] = String(mixtape.id)
        
        WhiteLabel.ListTracks(parameters: parameters, page: page, success: success, failure: failure)
    }
    
    public class func ListTracks(parameters parameters: [String: AnyObject]?, page: UInt, success: ([Track]! -> Void), failure: (BackendError! -> Void)) {
        
        var params = parameters != nil ? parameters! : [String: AnyObject]()
        params["page"] = String(page)
        
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
    
    public class func GetTrack(id: AnyObject, success: (Track! -> Void), failure: (BackendError! -> Void)) {
        
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
