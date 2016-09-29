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

public enum Router: URLRequestConvertible {
    
    // Label
    case getLabel
    
    // Collection
    case listCollections(parameters: [String: AnyObject]?)
    case createCollection(parameters: [String: AnyObject]?)
    case getCollection(id: AnyObject)
    case updateCollection(id: AnyObject, parameters: [String: AnyObject])
    case deleteCollection(id: AnyObject)
    
    // Mixtape
    case listMixtapes(parameters: [String: AnyObject]?)
    case createMixtape(parameters: [String: AnyObject]?)
    case getMixtape(id: AnyObject)
    case updateMixtape(id: AnyObject, parameters: [String: AnyObject]?)
    case deleteMixtape(id: AnyObject)
    
    // Track
    case listTracks(parameters: [String: AnyObject]?)
    case createTrack(parameters: [String: AnyObject]?)
    case getTrack(id: AnyObject)
    case updateTrack(id: AnyObject, parameters: [String: AnyObject]?)
    case deleteTrack(id: AnyObject)
    
    public var method: Alamofire.Method {
        switch self {
            
        // Label
        case .getLabel:
            return .GET
            
        // Collection
        case .listCollections:
            return .GET
        case .createCollection:
            return .POST
        case .getCollection:
            return .GET
        case .updateCollection:
            return .PUT
        case .deleteCollection:
            return .DELETE
            
        // Mixtape
        case .listMixtapes:
            return .GET
        case .createMixtape:
            return .POST
        case .getMixtape:
            return .GET
        case .updateMixtape:
            return .PUT
        case .deleteMixtape:
            return .DELETE
            
        // Track
        case .listTracks:
            return .GET
        case .createTrack:
            return .POST
        case .getTrack:
            return .GET
        case .updateTrack:
            return .PUT
        case .deleteTrack:
            return .DELETE
            
        }
    }
    
    public var path: String {
        switch self {
            
        // Label
        case .getLabel:
            return "/label/"
            
        // Collection
        case .listCollections:
            return "/collections/"
        case .createCollection:
            return "/collections/"
        case .getCollection(let id):
            return "/collections/\(id)/"
        case .updateCollection(let id, _):
            return "/collections/\(id)/"
        case .deleteCollection(let id):
            return "/collections/\(id)/"
            
        // Mixtape
        case .listMixtapes:
            return "/mixtapes/"
        case .createMixtape:
            return "/mixtapes/"
        case .getMixtape(let id):
            return "/mixtapes/\(id)/"
        case .updateMixtape(let id, _):
            return "/mixtapes/\(id)/"
        case .deleteMixtape(let id):
            return "/mixtapes/\(id)/"
            
        // Track
        case .listTracks:
            return "/tracks/"
        case .createTrack:
            return "/tracks/"
        case .getTrack(let id):
            return "/tracks/\(id)/"
        case .updateTrack(let id, _):
            return "/tracks/\(id)/"
        case .deleteTrack(let id):
            return "/tracks/\(id)/"

        }
    }
    
    public var URLRequest: NSMutableURLRequest {
        let URL = Foundation.URL(string: WhiteLabel.BaseURLString)!
        let mutableURLRequest = NSMutableURLRequest(url: URL.appendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        assert(WhiteLabel.ClientID != nil, "No Client ID provided.")
        
        mutableURLRequest.setValue(WhiteLabel.ClientID!, forHTTPHeaderField: "Client")
        mutableURLRequest.setValue("application/json; version=" + WhiteLabel.Version, forHTTPHeaderField: "Accept")
        
        switch self {
            
        // Label
        case .getLabel:
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
            
        // Collection
        case .listCollections(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .createCollection(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .getCollection:
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
        case .updateCollection(_, let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .deleteCollection:
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
            
        // Mixtape
        case .listMixtapes(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .createMixtape(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .getMixtape:
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
        case .updateMixtape(_, let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .deleteMixtape:
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
            
        // Track
        case .listTracks(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .createTrack(let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .getTrack:
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
        case .updateTrack(_, let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .deleteTrack:
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0

        }
    }
}

public enum BackendError: Error {
    case network(statusCode: Int, error: NSError)
    case jsonSerialization(error: NSError)
    case objectSerialization(reason: String)
}

public protocol ResponseObjectSerializable {
    init?(response: HTTPURLResponse, representation: AnyObject)
}

extension Request {
    public func responseObject<T: ResponseObjectSerializable>(_ completionHandler: (Response<T, BackendError>) -> Void) -> Self {
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
                    let responseObject = T(response: response, representation: value)
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
    static func collection(response: HTTPURLResponse, representation: AnyObject) -> [Self]
}

extension ResponseCollectionSerializable where Self: ResponseObjectSerializable {
    public static func collection(response: HTTPURLResponse, representation: AnyObject) -> [Self] {
        
        var collection = [Self]()
        
        if let representation = representation as? [String: AnyObject] {
            let results = representation["results"]
            if let results = results as? [[String: AnyObject]] {
                for resultItem in results {
                    if let item = Self(response: response, representation: resultItem as AnyObject) {
                        collection.append(item)
                    }
                }
            }
        }
        
        return collection
    }
}

extension Request {
    public func responseCollection<T: ResponseCollectionSerializable>(_ completionHandler: (Response<[T], BackendError>) -> Void) -> Self {
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
