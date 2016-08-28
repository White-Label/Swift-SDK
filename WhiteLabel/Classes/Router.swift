//
//  Router.swift
//
//  Created by Alex Givens http://alexgivens.com on 8/28/16
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

enum Router: URLRequestConvertible {
    
    // Label
    case GetLabel
    
    // Collection
    case ListCollections(parameters: [String: AnyObject]?)
    case CreateCollection(parameters: [String: AnyObject]?)
    case GetCollection(id: AnyObject)
    case UpdateCollection(id: AnyObject, parameters: [String: AnyObject])
    case DeleteCollection(id: AnyObject)
    
    // Mixtape
    case ListMixtapes(parameters: [String: AnyObject]?)
    case CreateMixtape(parameters: [String: AnyObject]?)
    case GetMixtape(id: AnyObject)
    case UpdateMixtape(id: AnyObject, parameters: [String: AnyObject]?)
    case DeleteMixtape(id: AnyObject)
    
    // Track
    case ListTracks(parameters: [String: AnyObject]?)
    case CreateTrack(parameters: [String: AnyObject]?)
    case GetTrack(id: AnyObject)
    case UpdateTrack(id: AnyObject, parameters: [String: AnyObject]?)
    case DeleteTrack(id: AnyObject)
    
    var method: Alamofire.Method {
        switch self {
            
        // Label
        case .GetLabel:
            return .GET
            
        // Collection
        case .ListCollections:
            return .GET
        case .CreateCollection:
            return .POST
        case .GetCollection:
            return .GET
        case .UpdateCollection:
            return .PUT
        case .DeleteCollection:
            return .DELETE
            
        // Mixtape
        case .ListMixtapes:
            return .GET
        case .CreateMixtape:
            return .POST
        case .GetMixtape:
            return .GET
        case .UpdateMixtape:
            return .PUT
        case .DeleteMixtape:
            return .DELETE
            
        // Track
        case .ListTracks:
            return .GET
        case .CreateTrack:
            return .POST
        case .GetTrack:
            return .GET
        case .UpdateTrack:
            return .PUT
        case .DeleteTrack:
            return .DELETE
            
        }
    }
    
    var path: String {
        switch self {
            
        // Label
        case .GetLabel:
            return "/label/"
            
        // Collection
        case .ListCollections:
            return "/collections/"
        case .CreateCollection:
            return "/collections/"
        case .GetCollection(let id):
            return "/collections/\(id)/"
        case .UpdateCollection(let id, _):
            return "/collections/\(id)/"
        case .DeleteCollection(let id):
            return "/collections/\(id)/"
            
        // Mixtape
        case .ListMixtapes:
            return "/mixtapes/"
        case .CreateMixtape:
            return "/mixtapes/"
        case .GetMixtape(let id):
            return "/mixtapes/\(id)/"
        case .UpdateMixtape(let id, _):
            return "/mixtapes/\(id)/"
        case .DeleteMixtape(let id):
            return "/mixtapes/\(id)/"
            
        // Track
        case .ListTracks:
            return "/tracks/"
        case .CreateTrack:
            return "/tracks/"
        case .GetTrack(let id):
            return "/tracks/\(id)/"
        case .UpdateTrack(let id, _):
            return "/tracks/\(id)/"
        case .DeleteTrack(let id):
            return "/tracks/\(id)/"

        }
    }
    
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: WhiteLabel.BaseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        assert(WhiteLabel.ClientID != nil, "No Client ID provided.")
        
        mutableURLRequest.setValue(WhiteLabel.ClientID!, forHTTPHeaderField: "Client")
        mutableURLRequest.setValue("application/json; version=" + WhiteLabel.Version, forHTTPHeaderField: "Accept")
        
        switch self {
            
        // Label
        case .GetLabel:
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
            
        // Collection
        case .ListCollections(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .CreateCollection(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .GetCollection:
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
        case .UpdateCollection(_, let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .DeleteCollection:
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
            
        // Mixtape
        case .ListMixtapes(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .CreateMixtape(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .GetMixtape:
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
        case .UpdateMixtape(_, let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .DeleteMixtape:
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
            
        // Track
        case .ListTracks(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .CreateTrack(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .GetTrack:
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
        case .UpdateTrack(_, let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .DeleteTrack:
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0

        }
    }
}

public enum BackendError: ErrorType {
    case Network(statusCode: Int, error: NSError)
    case JSONSerialization(error: NSError)
    case ObjectSerialization(reason: String)
}

public protocol ResponseObjectSerializable {
    init?(response: NSHTTPURLResponse, representation: AnyObject)
}

extension Request {
    public func responseObject<T: ResponseObjectSerializable>(completionHandler: Response<T, BackendError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<T, BackendError> { request, response, data, error in
            guard error == nil else {
                return .Failure(.Network(statusCode: response != nil ? response!.statusCode : 0, error: error!))
            }
            
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

public protocol ResponseCollectionSerializable {
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Self]
}

extension ResponseCollectionSerializable where Self: ResponseObjectSerializable {
    public static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Self] {
        
        var collection = [Self]()
        
        if let representation = representation as? [String: AnyObject] {
            let results = representation["results"]
            if let results = results as? [[String: AnyObject]] {
                for resultItem in results {
                    if let item = Self(response: response, representation: resultItem) {
                        collection.append(item)
                    }
                }
            }
        }
        
        return collection
    }
}

extension Request {
    public func responseCollection<T: ResponseCollectionSerializable>(completionHandler: Response<[T], BackendError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<[T], BackendError> { request, response, data, error in
            guard error == nil else {
                return .Failure(.Network(statusCode: response != nil ? response!.statusCode : 0, error: error!))
            }
            
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .Success(let value):
                if let response = response {
                    return .Success(T.collection(response: response, representation: value))
                } else {
                    return .Failure(. ObjectSerialization(reason: "Response collection could not be serialized due to nil response"))
                }
            case .Failure(let error):
                return .Failure(.JSONSerialization(error: error))
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}