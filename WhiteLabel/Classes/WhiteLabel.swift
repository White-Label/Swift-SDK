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
    public static let errorDomain: String = "cool.whitelabel.swift"
    
    public enum Path: String {
        case Label = "/api/label/"
        case Collection = "/api/collections/"
        case Mixtape = "/api/mixtapes/"
        case Track = "/api/tracks/"
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
    
    private class func initializeRestKit() {
        let baseURL = NSURL(string: WhiteLabel.baseURL)
        let client = AFRKHTTPClient(baseURL: baseURL)
        
        client.setDefaultHeader("Client", value: WhiteLabel.clientID)
        client.setDefaultHeader("Accept", value: "application/json; version=" + apiVersion)
        
        // initialize RestKit
        let objectManager = RKObjectManager(HTTPClient: client)
        
        // Setup Label Mapping
        let labelMapping = RKObjectMapping(forClass: Label.self)
        labelMapping.addAttributeMappingsFromDictionary([
            "id":       "id",
            "name":     "name",
            "slug":     "slug",
            "icon":     "iconURL",
            ]
        )
        
        let serviceMapping = RKObjectMapping(forClass: Service.self)
        serviceMapping.addAttributeMappingsFromDictionary([
            "id":               "id",
            "name":             "name",
            "slug":             "slug",
            "external_url":     "externalURL",
            ]
        )
        
        labelMapping.addPropertyMapping(RKRelationshipMapping(fromKeyPath: "service", toKeyPath: "service", withMapping: serviceMapping))
        
        let labelResponseDescriptor = RKResponseDescriptor(
            mapping: labelMapping,
            method: .GET,
            pathPattern: Path.Label.rawValue,
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
        collectionMapping.addAttributeMappingsFromDictionary([
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
        )
        
        let collectionList = RKResponseDescriptor(
            mapping: collectionMapping,
            method: .GET,
            pathPattern: Path.Collection.List(),
            keyPath: "results",
            statusCodes: NSIndexSet(index: 200)
        )
        
        objectManager.addResponseDescriptor(collectionList)
        
        let collectionDetail = RKResponseDescriptor(
            mapping: collectionMapping,
            method: .GET,
            pathPattern: Path.Collection.Detail(),
            keyPath: nil,
            statusCodes: NSIndexSet(index: 200)
        )

        objectManager.addResponseDescriptor(collectionDetail)
        
        // Setup Mixtape Mapping
        let mixtapeMapping = RKObjectMapping(forClass: Mixtape.self)
        mixtapeMapping.addAttributeMappingsFromDictionary([
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
        )
        
        let mixtapeList = RKResponseDescriptor(
            mapping: mixtapeMapping,
            method: .GET,
            pathPattern: Path.Mixtape.List(),
            keyPath: "results",
            statusCodes: NSIndexSet(index: 200)
        )
        
        objectManager.addResponseDescriptor(mixtapeList)
        
        let mixtapeDetail = RKResponseDescriptor(
            mapping: mixtapeMapping,
            method: .GET,
            pathPattern: Path.Mixtape.Detail(),
            keyPath: nil,
            statusCodes: NSIndexSet(index: 200)
        )
        
        objectManager.addResponseDescriptor(mixtapeDetail)
        
        // Setup Track Mapping
        let trackMapping = RKObjectMapping(forClass: Track.self)
        trackMapping.addAttributeMappingsFromDictionary([
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
        )
        
        let trackList = RKResponseDescriptor(
            mapping: trackMapping,
            method: .GET,
            pathPattern: Path.Track.List(),
            keyPath: "results",
            statusCodes: NSIndexSet(index: 200)
        )
        
        objectManager.addResponseDescriptor(trackList)
        
        let trackDetail = RKResponseDescriptor(
            mapping: trackMapping,
            method: .GET,
            pathPattern: Path.Track.Detail(),
            keyPath: nil,
            statusCodes: NSIndexSet(index: 200)
        )
        
        objectManager.addResponseDescriptor(trackDetail)
        
        RKlcl_configure_by_name("*", RKlcl_vOff.rawValue);
    }
    
    public class func getLabelDetail(success success: (Label! -> Void), failure: (NSError! -> Void)) {
        
        WhiteLabel.getDetail(
            .Label,
            identifier: nil, // Identity is inferred
            success: { object in
                if let label = object as? Label {
                    success(label)
                } else {
                    let error = NSError(domain: WhiteLabel.errorDomain, code: NSURLErrorCannotParseResponse, userInfo: [
                        NSLocalizedDescriptionKey: "Unable to cast returned obect as Label."
                        ])
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
    
    private class func getList(path: Path, forPage page: UInt, withParameters parameters: [NSObject: AnyObject]?, success: (objects: [AnyObject]) -> Void, failure: (error: NSError) -> Void) -> Void {
        
        let fullPath = path.List() + "?page=:currentPage"
        
        let paginator = RKObjectManager.sharedManager().paginatorWithPathPattern(fullPath, parameters: parameters)
        paginator.perPage = 20
        
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
    
    private class func getDetail(path: Path, identifier: String?, success: (object: AnyObject) -> Void, failure: (error: NSError) -> Void) -> Void {
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
}
