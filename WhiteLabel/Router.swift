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
    case listCollections(parameters: Parameters?)
    case createCollection(parameters: Parameters?)
    case getCollection(id: Any)
    case updateCollection(id: Any, parameters: Parameters?)
    case deleteCollection(id: Any)
    
    // Mixtape
    case listMixtapes(parameters: Parameters?)
    case createMixtape(parameters: Parameters?)
    case getMixtape(id: Any)
    case updateMixtape(id: Any, parameters: Parameters?)
    case deleteMixtape(id: Any)
    
    // Track
    case listTracks(parameters: Parameters?)
    case createTrack(parameters: Parameters?)
    case getTrack(id: Any)
    case updateTrack(id: Any, parameters: Parameters?)
    case deleteTrack(id: Any)
    
    public var method: HTTPMethod {
        switch self {
            
        // Label
        case .getLabel:
            return .get
            
        // Collection
        case .listCollections:
            return .get
        case .createCollection:
            return .post
        case .getCollection:
            return .get
        case .updateCollection:
            return .put
        case .deleteCollection:
            return .delete
            
        // Mixtape
        case .listMixtapes:
            return .get
        case .createMixtape:
            return .post
        case .getMixtape:
            return .get
        case .updateMixtape:
            return .put
        case .deleteMixtape:
            return .delete
            
        // Track
        case .listTracks:
            return .get
        case .createTrack:
            return .post
        case .getTrack:
            return .get
        case .updateTrack:
            return .put
        case .deleteTrack:
            return .delete
            
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
    
    public func asURLRequest() throws -> URLRequest {
        let url = try Constants.BaseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        assert(Constants.ClientID.isEmpty == false, "No Client ID provided.")
        
        urlRequest.setValue("application/json; version=" + Constants.Version, forHTTPHeaderField: "Accept")
        urlRequest.setValue(Constants.ClientID, forHTTPHeaderField: "Client")
        
        switch self {
            
        // Label
        case .getLabel:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
            
        // Collection
        case .listCollections(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .createCollection(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .getCollection:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .updateCollection(_, let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .deleteCollection:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
            
        // Mixtape
        case .listMixtapes(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .createMixtape(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .getMixtape:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .updateMixtape(_, let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .deleteMixtape:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
            
        // Track
        case .listTracks(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .createTrack(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .getTrack:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        case .updateTrack(_, let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .deleteTrack:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)

        }
        
        return urlRequest
    }
}
