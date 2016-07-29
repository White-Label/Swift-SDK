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
    
    private static let baseURL: String = "https://beta.whitelabel.cool"
    public static var clientID: String? {
        didSet {
            WhiteLabel.initializeRestKit()
        }
    }
    
    private class func initializeRestKit() {
        let baseURL = NSURL(string: WhiteLabel.baseURL)
        let client = AFRKHTTPClient(baseURL: baseURL)
        
        client.setDefaultHeader("Client", value: WhiteLabel.clientID)
        client.setDefaultHeader("Accept", value: "application/json; version=1.0")
        
        // initialize RestKit
        let objectManager = RKObjectManager(HTTPClient: client)
        
        // Setup Collection Mapping
        let collectionMapping = RKObjectMapping(forClass: Collection.self)
        
        let collectionAttributeMap = [
            "title" : "title",
            "slug" : "slug"
        ]
        
        collectionMapping.addAttributeMappingsFromDictionary(collectionAttributeMap)
        
        let collectionResponseDescriptor = RKResponseDescriptor(
            mapping: collectionMapping,
            method: .GET,
            pathPattern: "/api/collections/",
            keyPath: "results",
            statusCodes: NSIndexSet(index: 200)
        )
        
        objectManager.addResponseDescriptor(collectionResponseDescriptor)
        
        // Setup Mixtape Mapping
        let mixtapeMapping = RKObjectMapping(forClass: Mixtape.self)
        
        let mixtapeAttributeMap = [
            "title" : "title",
            "slug" : "slug"
        ]
        
        mixtapeMapping.addAttributeMappingsFromDictionary(mixtapeAttributeMap)
        
        let mixtapeResponseDescriptor = RKResponseDescriptor(
            mapping: mixtapeMapping,
            method: .GET,
            pathPattern: "/api/mixtapes/",
            keyPath: "results",
            statusCodes: NSIndexSet(index: 200)
        )
        
        objectManager.addResponseDescriptor(mixtapeResponseDescriptor)
    }
    
    public class func getLabel(success: (Label!), failure: (NSError!)) {
        
    }
    
    public class func getCollections(ordering: String?, search: String?, success: ([Collection]! -> Void), failure: (NSError! -> Void)) {
        
        var parameters = [NSObject: AnyObject]()
        
        if ordering != nil {
            parameters["ordering"] = ordering!
        }
        
        if search != nil {
            parameters["search"] = search!
        }
        
        RKObjectManager.sharedManager().getObjectsAtPath(
            "/api/collections/",
            parameters: parameters,
            success: { operation, result in
                if let collections = result.array() as? [Collection] {
                    success(collections)
                } else {
                    let error = NSError(
                        domain: NSURLErrorDomain,
                        code: NSURLErrorCannotOpenFile,
                        userInfo: nil)
                    failure(error)
                }
            }, failure: { operation, error in
                failure(error)
            }
        )
    }
    
    public class func getCollection(success: (Collection! -> Void), failure: (NSError! -> Void)) {
        
    }
    
    public class func getMixtapes(forCollection: Collection?, success: ([Mixtape]! -> Void), failure: (NSError! -> Void)) {
        
        var parameters = [NSObject: AnyObject]()
        
        if let collection = forCollection {
            parameters["collection"] = collection.slug
        }
        
        RKObjectManager.sharedManager().getObjectsAtPath(
            "/api/mixtapes/",
            parameters: parameters,
            success: { operation, result in
                if let mixtapes = result.array() as? [Mixtape] {
                    success(mixtapes)
                } else {
                    let error = NSError(
                        domain: NSURLErrorDomain,
                        code: NSURLErrorCannotOpenFile,
                        userInfo: nil)
                    failure(error)
                }
            }, failure: { operation, error in
                failure(error)
            }
        )
    }
    
    public class func getMixtape(success: (Mixtape! -> Void), failure: (NSError! -> Void)) {
        
    }
    
    public class func getTracks(forMixtape: Mixtape?, success: ([Track]! -> Void), failure: (NSError! -> Void)) {
        
        var parameters = [NSObject: AnyObject]()
        
        if forMixtape != nil {
            parameters["mixtape"] = String(forMixtape!.id)
        }
        
        RKObjectManager.sharedManager().getObjectsAtPath(
            "/api/tracks/",
            parameters: parameters,
            success: { operation, result in
                if let tracks = result.array() as? [Track] {
                    success(tracks)
                } else {
                    let error = NSError(
                        domain: NSURLErrorDomain,
                        code: NSURLErrorCannotOpenFile,
                        userInfo: nil)
                    failure(error)
                }
            }, failure: { operation, error in
                failure(error)
            }
        )
    }
    
    public class func getTrack(success: (Track! -> Void), failure: (NSError! -> Void)) {
        
    }
}
