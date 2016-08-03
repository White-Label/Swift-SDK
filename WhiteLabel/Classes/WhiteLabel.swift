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
import RestKit

public class WhiteLabel {
    
    public static var baseURL: String = "https://beta.whitelabel.cool"
    public static var apiVersion: String = "1.0"
    public static var pageSize: Int = 20
    public static var clientID: String? {
        didSet {
            WhiteLabel.initializeRestKit()
        }
    }
    
    public enum Filter {
        case Order([String], Direction)
        case Search(string: String)
        case Collection(id: NSNumber)
        case Mixtape(id: NSNumber)
        public enum Direction {
            case Ascending
            case Descending
        }
    }
    
    public enum ReturnType {
        public enum List {
            case Collections
            case Mixtapes
            case Tracks
            func path() -> String {
                switch self {
                case .Collections: return "/api/collections/"
                case .Mixtapes: return "/api/mixtapes/"
                case .Tracks: return "/api/tracks/"
                }
            }
        }
        public enum Detail {
            case Label, Collection, Mixtape, Track
        }
        
        
    }
    
    private class func initializeRestKit() {
        let baseURL = NSURL(string: WhiteLabel.baseURL)
        let client = AFRKHTTPClient(baseURL: baseURL)
        
        client.setDefaultHeader("Client", value: WhiteLabel.clientID)
        client.setDefaultHeader("Accept", value: "application/json; version=" + apiVersion)
        
        // initialize RestKit
        let objectManager = RKObjectManager(HTTPClient: client)
        
        // Setup Label Mapping
        let labelMapping = RKObjectMapping(forClass: Label.self)
        
        let labelAttributeMap = [
            "id":       "id",
            "name":     "name",
            "slug":     "slug",
            "icon":     "iconURL",
        ]
        
        labelMapping.addAttributeMappingsFromDictionary(labelAttributeMap)
        
        let labelResponseDescriptor = RKResponseDescriptor(
            mapping: labelMapping,
            method: .GET,
            pathPattern: "/api/label/",
            keyPath: nil,
            statusCodes: NSIndexSet(index: 200)
        )
        
        objectManager.addResponseDescriptor(labelResponseDescriptor)
        
        // Setup Pagination Mapping
        let paginationMapping = RKObjectMapping(forClass: RKPaginator.self)
        
        let pagingAttributeMap = [
            "count":    "objectCount",
        ]
        
        paginationMapping.addAttributeMappingsFromDictionary(pagingAttributeMap)
        
        objectManager.paginationMapping = paginationMapping
        
        // Setup Collection Mapping
        let collectionMapping = RKObjectMapping(forClass: Collection.self)
        
        let collectionAttributeMap = [
            "id":                   "id",
            "title":                "title",
            "slug":                 "slug",
            "description":          "_description",
            "artwork_url":          "artworkURL",
            "artwork_credit":       "artworkCredit",
            "artwork_credit_url":   "artworkCreditURL",
            "created":              "createdDate",
            "mixtape_count":        "mixtapeCount",
        ]
        
        collectionMapping.addAttributeMappingsFromDictionary(collectionAttributeMap)
        
        let collectionResponseDescriptor = RKResponseDescriptor(
            mapping: collectionMapping,
            method: .GET,
            pathPattern: ReturnType.List.Collections.path(),
            keyPath: "results",
            statusCodes: NSIndexSet(index: 200)
        )
        
        objectManager.addResponseDescriptor(collectionResponseDescriptor)
        
        // Setup Mixtape Mapping
        let mixtapeMapping = RKObjectMapping(forClass: Mixtape.self)
        
        let mixtapeAttributeMap = [
            "id":                   "id",
            "title":                "title",
            "slug":                 "slug",
            "description":          "_description",
            "artwork_url":          "artworkURL",
            "artwork_credit":       "artworkCredit",
            "artwork_credit_url":   "artworkCreditURL",
            "sponsor":              "sponsor",
            "sponsor_url":          "sponsorURL",
            "product":              "product",
            "product_url":          "productURL",
            "release":              "releaseDate",
            "track_count":          "trackCount",
            "collection":           "collectionID",
        ]
        
        mixtapeMapping.addAttributeMappingsFromDictionary(mixtapeAttributeMap)
        
        let mixtapeResponseDescriptor = RKResponseDescriptor(
            mapping: mixtapeMapping,
            method: .GET,
            pathPattern: ReturnType.List.Mixtapes.path(),
            keyPath: "results",
            statusCodes: NSIndexSet(index: 200)
        )
        
        objectManager.addResponseDescriptor(mixtapeResponseDescriptor)
        
        // Setup Track Mapping
        let trackMapping = RKObjectMapping(forClass: Track.self)
        
        let trackAttributeMap = [
            "id":             "id",
            "title":            "title",
            "artist":           "artist",
            "slug":             "slug",
            "streamable":       "streamable",
            "duration":         "duration",
            "external_id":      "externalID",
            "stream_url":       "streamURL",
            "permalink_url":    "permalinkURL",
            "artwork_url":      "artworkURL",
            "purchase_url":     "purchaseURL",
            "download_url":     "downloadURL",
            "ticket_url":       "ticketURL",
            "play_count":       "playCount",
            "order":            "order",
        ]
        
        trackMapping.addAttributeMappingsFromDictionary(trackAttributeMap)
        
        let trackResponseDescriptor = RKResponseDescriptor(
            mapping: trackMapping,
            method: .GET,
            pathPattern: ReturnType.List.Tracks.path(),
            keyPath: "results",
            statusCodes: NSIndexSet(index: 200)
        )
        
        objectManager.addResponseDescriptor(trackResponseDescriptor)
    }
    
    public class func getLabel(success success: (Label! -> Void), failure: (NSError! -> Void)) {
        
        RKObjectManager.sharedManager().getObjectsAtPath(
            "/api/label/",
            parameters: nil,
            success: { operation, result in
                if let label = result.firstObject as? Label {
                    success(label)
                } else {
                    let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorCannotOpenFile, userInfo: nil)
                    failure(error)
                }
            },
            failure: { operation, error in
                failure(error)
            }
        )
    }
    
    public class func getCollections(parameters parameters: [NSObject: AnyObject]?, page: UInt, success: ([Collection]! -> Void), failure: (NSError! -> Void)) {
        WhiteLabel.get(
            .Collections,
            forPage: page,
            withParameters: parameters,
            success: { objects in
                if let collections = objects as? [Collection] {
                    success(collections)
                } else {
                    let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorCannotOpenFile, userInfo: nil)
                    failure(error)
                }
            },
            failure: { error in
                failure(error)
            }
        )
    }
    
    public class func getMixtapesForCollection(collection: Collection, page: UInt, success: ([Mixtape]! -> Void), failure: (NSError! -> Void)) {
        
        var parameters = [NSObject: AnyObject]()
        parameters["collection"] = String(collection.id)
        
        WhiteLabel.getMixtapes(parameters: parameters, page: page, success: success, failure: failure)
    }
    
    public class func getMixtapes(parameters parameters: [NSObject: AnyObject]?, page: UInt, success: ([Mixtape]! -> Void), failure: (NSError! -> Void)) {
        WhiteLabel.get(
            .Mixtapes,
            forPage: page,
            withParameters: parameters,
            success: { objects in
                if let mixtapes = objects as? [Mixtape] {
                    success(mixtapes)
                } else {
                    let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorCannotOpenFile, userInfo: nil)
                    failure(error)
                }
            },
            failure: { error in
                failure(error)
            }
        )
    }
    
    public class func getTracksForMixtape(mixtape: Mixtape, page: UInt, success: ([Track]! -> Void), failure: (NSError! -> Void)) {
        
        var parameters = [NSObject: AnyObject]()
        parameters["mixtape"] = String(mixtape.id)
        
        WhiteLabel.getTracks(parameters: parameters, page: page, success: success, failure: failure)
    }
    
    public class func getTracks(parameters parameters: [NSObject: AnyObject]?, page: UInt, success: ([Track]! -> Void), failure: (NSError! -> Void)) {
        WhiteLabel.get(
            .Tracks,
            forPage: page,
            withParameters: parameters,
            success: { objects in
                if let tracks = objects as? [Track] {
                    success(tracks)
                } else {
                    let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorCannotOpenFile, userInfo: nil)
                    failure(error)
                }
            },
            failure: { error in
                failure(error)
            }
        )
    }
    
    private class func get(returnType: ReturnType.List, forPage page: UInt, withParameters parameters: [NSObject: AnyObject]?, success: (objects: [AnyObject]) -> Void, failure: (error: NSError) -> Void) -> Void {
        
        let path = returnType.path() + "?page=:currentPage"
        
        let paginator = RKObjectManager.sharedManager().paginatorWithPathPattern(path, parameters: parameters)
        paginator.perPage = 20
        
        paginator.setCompletionBlockWithSuccess({ paginator, objects, page in
            success(objects: objects)
            },
                                                failure: { paginator, error in
                                                    failure(error: error)
            }
        )
        
        paginator.loadPage(page)
    }
}
