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
import SwiftyJSON

public protocol ObjectURLStringConvertible {
    static var ObjectURLString: String { get }
}

public protocol ListURLStringConvertible {
    static var ListURLString: String { get }
}

//public protocol AllowedMethods {
//    var allowedMethods: [Alamofire.Method] { get set }
//}



//WhiteLabel.list(array, filters) {
//    
//}
//
//WhiteLabel.create(object) { result in
//    switch result {
//        .Success(let object):
//            //confirm created object
//        .Failure(let error):
//            //show error
//    }
//}
//
//WhiteLabel.get(object) {
//    
//}
//
//WhiteLabel.update(object) {
//    
//}
//
//WhiteLabel.delete(object) {
//    
//}



public enum Result<Value, Error: NSError> {
    case Success(Value)
    case Failure(Error)
    
    /// Returns `true` if the result is a success, `false` otherwise.
    public var isSuccess: Bool {
        switch self {
        case .Success:
            return true
        case .Failure:
            return false
        }
    }
    
    /// Returns `true` if the result is a failure, `false` otherwise.
    public var isFailure: Bool {
        return !isSuccess
    }
    
    /// Returns the associated value if the result is a success, `nil` otherwise.
    public var value: Value? {
        switch self {
        case .Success(let value):
            return value
        case .Failure:
            return nil
        }
    }
    
    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    public var error: Error? {
        switch self {
        case .Success:
            return nil
        case .Failure(let error):
            return error
        }
    }
}

public protocol WhiteLabelReturnType {
    static var ListURLString: String { get }
    
    init(fromJson json: JSON!)
}

/***************/

public enum BackendError: ErrorType {
    case Network(error: NSError)
    case DataSerialization(reason: String)
    case JSONSerialization(error: NSError)
    case ObjectSerialization(reason: String)
    case XMLSerialization(error: NSError)
}

public protocol ResponseObjectSerializable {
    init?(response: NSHTTPURLResponse, representation: AnyObject)
}

extension Request {
    public func responseObject<T: ResponseObjectSerializable>(completionHandler: Response<T, BackendError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<T, BackendError> { request, response, data, error in
            guard error == nil else { return .Failure(.Network(error: error!)) }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .Success(let value):
                if let
                    response = response,
                    responseObject = T(response: response, representation: value)
                {
                    return .Success(responseObject)
                } else {
                    return .Failure(.ObjectSerialization(reason: "JSON could not be serialized into response object: \(value)"))
                }
            case .Failure(let error):
                return .Failure(.JSONSerialization(error: error))
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}


public protocol ResponseListSerializable {
    static func list(response response: NSHTTPURLResponse, representation: AnyObject) -> [Self]
}

extension ResponseListSerializable where Self: ResponseObjectSerializable {
    public static func list(response response: NSHTTPURLResponse, representation: AnyObject) -> [Self] {
        var list = [Self]()
        
        if let representation = representation as? [[String: AnyObject]] {
            for itemRepresentation in representation {
                if let item = Self(response: response, representation: itemRepresentation) {
                    list.append(item)
                }
            }
        }
        
        return list
    }
}

extension Alamofire.Request {
    public func responseList<T: ResponseListSerializable>(completionHandler: Response<[T], BackendError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<[T], BackendError> { request, response, data, error in
            guard error == nil else { return .Failure(.Network(error: error!)) }
            
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .Success(let value):
                if let response = response {
                    return .Success(T.list(response: response, representation: value))
                } else {
                    return .Failure(. ObjectSerialization(reason: "Response list could not be serialized due to nil response"))
                }
            case .Failure(let error):
                return .Failure(.JSONSerialization(error: error))
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}

/***************/



public class Testing123 {
    
    public enum ListType {
        case Collections
        case Mixtapes
        case Tracks
    }
    
    public class func coolio () {
        
        Alamofire.request(.GET, "url").responseList { (response: Response<[Mixtape], BackendError>) in
            switch response.result {
            case .Success(let mixtapes):
                print("Mixtapes: \(mixtapes)")
            case .Failure(let error):
                print("Error: \(error)")
            }
        }
        
        WhiteLabel.list<Mixtape>(1, filters: nil, Mixtape.self) { collections<Collection> in
            
        }
        
    }
    
}


public class WhiteLabel {
    
    public class func list<T: WhiteLabelReturnType>(page: UInt = 1, filters: [String: String]? = nil, returningType: T.Type,  completion: [T] -> Void) {
        
        let parameters = [
            "page": String(page)
        ]
        
        Alamofire.request(.GET, T.ListURLString, parameters: parameters).responseJSON { response in
            switch response.result {
            case .Success(let data):
                if let jsonArray = JSON(data).array {
                    var objects: [T]
                    for jsonObject in jsonArray {
                        let convertedObject = T.init(fromJson: jsonObject)
                        objects.append(convertedObject)
                    }
                    if objects.count > 0 {
                        completion(objects)
                    } else {
                        // Failure
                    }
                } else {
                    // Failure
                }
                
            case .Failure(_):
                print("error")
            }
        }
        return true
    }
    
    
    
    
    public static var apiVersion: String = "1.0"
    public static var pageSize: UInt = 20
    public static var clientID: String? {
        didSet {
            WhiteLabel.initialize()
        }
    }
    
    public enum Type {
        case Collection
        case Mixtape
        case Track
        
        var ListPath: NSURL? {
            var urlString: String
            switch self {
            case Collection:
                urlString = "/collections/"
            case Mixtape:
                urlString = "/mixtapes/"
            case Track:
                urlString = "/tracks/"
            }
            return NSURL(string: urlString)
        }
        
        
        func List() -> String {
            return self.rawValue
        }
        func Detail() -> String {
            if self == Label {
                return self.rawValue
            }
            return self.rawValue + ":id/"
        }
        func detailWith(identifier: String?) -> String {
            if identifier == nil || self == Label {
                return self.rawValue
            }
            return self.rawValue + identifier! + "/"
        }
    }
    
    private class func initialize() {
        
        validateClientID()
        
        let thing = Constant.baseURLString
        
        WhiteLabel.headers = [
            "Client": WhiteLabel.clientID!,
            "Accept": "application/json; version=" + apiVersion
        ]
        
        
        let URL = NSURL(string: WhiteLabel.baseURL)
        let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        // set header fields
        URLRequest.setValue("a", forHTTPHeaderField: "Authorization")
        
        let encoding = Alamofire.ParameterEncoding.URL
        return encoding.encode(URLRequest, parameters: parameters).0
        
        
        
        
        let baseURL = NSURL(string: WhiteLabel.baseURL)
        let client = AFRKHTTPClient(baseURL: baseURL)
        
        validateClientID()
        client.setDefaultHeader("Client", value: clientID)
        client.setDefaultHeader("Accept", value: "application/json; version=" + apiVersion)
        
        // initialize RestKit
        let objectManager = RKObjectManager(HTTPClient: client)

    }
    
    public class func getLabel(success success: (Label! -> Void), failure: (NSError! -> Void)) {
        
        WhiteLabel.getDetail(
            .Label,
            identifier: nil, // Identity is inferred
            success: { object in
                if let label = object as? Label {
                    success(label)
                } else {
                    let error = NSError(
                        domain: Constant.errorDomain,
                        code: NSURLErrorCannotParseResponse,
                        userInfo: [
                            NSLocalizedDescriptionKey: "Unable to cast returned obect as Label."
                        ]
                    )
                    failure(error)
                }
            },
            failure: failure
        )
    }
    
    public class func getCollections(parameters parameters: [NSObject: AnyObject]?, page: UInt, success: ([Collection]! -> Void), failure: (NSError! -> Void)) {
        WhiteLabel.getList(
            .Collection,
            forPage: page,
            withParameters: parameters,
            success: { objects in
                if let collections = objects as? [Collection] {
                    success(collections)
                } else {
                    let error = NSError(domain: WhiteLabel.errorDomain, code: NSURLErrorCannotParseResponse, userInfo: [
                        NSLocalizedDescriptionKey: "Unable to cast returned obects as Array<Collection>."
                        ])
                    failure(error)
                }
            },
            failure: failure
        )
    }
    
    public class func getCollectionDetail(identifier: AnyObject, success: (Collection! -> Void), failure: (NSError! -> Void)) {
        
        var uniqueID = identifier
        
        if let collection = identifier as? Collection {
            uniqueID = collection.id
        }
        
        WhiteLabel.getDetail(
            .Collection,
            identifier: String(uniqueID),
            success: { object in
                if let collection = object as? Collection {
                    success(collection)
                } else {
                    let error = NSError(domain: WhiteLabel.errorDomain, code: NSURLErrorCannotParseResponse, userInfo: [
                        NSLocalizedDescriptionKey: "Unable to cast returned obect as Collection."
                        ])
                    failure(error)
                }
            },
            failure: failure
        )
    }
    
    public class func getMixtapesForCollection(collection: Collection, page: UInt, success: ([Mixtape]! -> Void), failure: (NSError! -> Void)) {
        
        var parameters = [NSObject: AnyObject]()
        parameters["collection"] = String(collection.id)
        
        WhiteLabel.getMixtapes(parameters: parameters, page: page, success: success, failure: failure)
    }
    
    public class func getMixtapes(parameters parameters: [NSObject: AnyObject]?, page: UInt, success: ([Mixtape]! -> Void), failure: (NSError! -> Void)) {
        WhiteLabel.getList(
            .Mixtape,
            forPage: page,
            withParameters: parameters,
            success: { objects in
                if let mixtapes = objects as? [Mixtape] {
                    success(mixtapes)
                } else {
                    let error = NSError(domain: WhiteLabel.errorDomain, code: NSURLErrorCannotParseResponse, userInfo: [
                        NSLocalizedDescriptionKey: "Unable to cast returned obects as Array<Mixtape>."
                        ])
                    failure(error)
                }
            },
            failure: failure
        )
    }
    
    public class func getMixtapeDetail(identifier: AnyObject, success: (Mixtape! -> Void), failure: (NSError! -> Void)) {
        
        var uniqueID = identifier
        
        if let mixtape = identifier as? Mixtape {
            uniqueID = mixtape.id
        }
        
        WhiteLabel.getDetail(
            .Mixtape,
            identifier: String(uniqueID),
            success: { object in
                if let mixtape = object as? Mixtape {
                    success(mixtape)
                } else {
                    let error = NSError(domain: WhiteLabel.errorDomain, code: NSURLErrorCannotParseResponse, userInfo: [
                        NSLocalizedDescriptionKey: "Unable to cast returned obect as Mixtape."
                        ])
                    failure(error)
                }
            },
            failure: failure
        )
    }
    
    public class func getTracksForMixtape(mixtape: Mixtape, page: UInt, success: ([Track]! -> Void), failure: (NSError! -> Void)) {
        
        var parameters = [NSObject: AnyObject]()
        parameters["mixtape"] = String(mixtape.id)
        
        WhiteLabel.getTracks(parameters: parameters, page: page, success: success, failure: failure)
    }
    
    public class func getTracks(parameters parameters: [NSObject: AnyObject]?, page: UInt, success: ([Track]! -> Void), failure: (NSError! -> Void)) {
        WhiteLabel.getList(
            .Track,
            forPage: page,
            withParameters: parameters,
            success: { objects in
                if let tracks = objects as? [Track] {
                    success(tracks)
                } else {
                    let error = NSError(domain: WhiteLabel.errorDomain, code: NSURLErrorCannotParseResponse, userInfo: [
                        NSLocalizedDescriptionKey: "Unable to cast returned obects as Array<Track>."
                        ])
                    failure(error)
                }
            },
            failure: failure
        )
    }
    
    public class func getTrackDetail(identifier: AnyObject, success: (Track! -> Void), failure: (NSError! -> Void)) {
        
        var uniqueID = identifier
        
        if let track = identifier as? Track {
            uniqueID = track.id
        }
        
        WhiteLabel.getDetail(
            .Track,
            identifier: String(uniqueID),
            success: { object in
                if let track = object as? Track {
                    success(track)
                } else {
                    let error = NSError(domain: WhiteLabel.errorDomain, code: NSURLErrorCannotParseResponse, userInfo: [
                        NSLocalizedDescriptionKey: "Unable to cast returned obect as Track."
                        ]) 
                    failure(error)
                }
            },
            failure: failure
        )
    }
    
    public class func getList(path: Path, forPage page: UInt, withParameters parameters: [NSObject: AnyObject]?, success: (objects: [AnyObject]) -> Void, failure: (error: NSError) -> Void) -> Void {
        validateClientID()
        
        Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
        
        
        
        let fullPath = path.List() + "?page=:currentPage"
        
        let paginator = RKObjectManager.sharedManager().paginatorWithPathPattern(fullPath, parameters: parameters)
        paginator.perPage = WhiteLabel.pageSize
        
        paginator.setCompletionBlockWithSuccess(
            { paginator, objects, page in
                success(objects: objects)
            },
            failure: { paginator, error in
                failure(error: error)
            }
        )
        
        paginator.loadPage(page)
    }
    
    public class func getDetail(path: Path, identifier: String?, success: (object: AnyObject) -> Void, failure: (error: NSError) -> Void) -> Void {
        validateClientID()
        
        RKObjectManager.sharedManager().getObjectsAtPath(
            path.detailWith(identifier),
            parameters: nil,
            success: { operation, result in
                success(object: result.firstObject)
            },
            failure: { operation, error in
                failure(error: error)
            }
        )
    }

    private class func validateClientID() {
        assert(WhiteLabel.clientID != nil, "No Client ID found. Please ensure you provide a White Label API Client ID as per the README.\n")
        assert(WhiteLabel.clientID!.characters.count == 40, "Client ID is invalid. Must be 40 characters.\n")
    }
}
