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

public class WhiteLabel {
    
    public static var clientID: String? {
        didSet {
            self.headers = [
                "Client": self.clientID!,
                "Accept": "application/json; version=1.0"
            ]
        }
    }
    
    private static let baseURL: String = "http://beta.whitelabel.cool/api"
    private static var headers: [String: String]? = nil
    public static var label: Label?
    
    enum ReturnType {
        case List
        case Detail
    }
    
    enum Resource {
        case Label
        case Service
        case Collection
        case Mixtape
        case Track
    }
    
    
    public class func getLabel(completionHandler: (Label?, NSError?) -> Void) {
        
        let url = self.baseURL + "/label/"
        
        Alamofire.request(.GET, url, headers: self.headers).validate().responseJSON { response in
            
            self.printResponse(response)
            
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let jsonObject = JSON(value)
                    let label = Label(fromJson: jsonObject)
                    completionHandler(label, nil)
                } else {
                    // TODO: return custom NSError
                    completionHandler(nil, nil)
                }
            case .Failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    
    public class func getCollectionsList(parameters: [String: AnyObject]? = nil, completionHandler: ([Collection]?, NSError?) -> Void) {
        
        let url = self.baseURL + "/collections/"
        
        Alamofire.request(.GET, url, headers: self.headers).validate().responseJSON { response in
            
            self.printResponse(response)
            
            switch response.result {
            case .Success:
                
                if let value = response.result.value {
                    let jsonObject = JSON(value)
                    
                    let resultsArray = jsonObject["results"].arrayValue
                    
                    var collections = [Collection]()
                    
                    for result in resultsArray {
                        let collection = Collection(fromJson: result)
                        collections.append(collection)
                    }
                    
                    if let label = self.label {
                        label.collections = collections
                    }
                    
                    completionHandler(collections, nil)
                } else {
                    // TODO: return custom NSError
                    completionHandler(nil, nil)
                }
                
            case .Failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    public class func getCollectionDetail(collectionID: AnyObject!, completionHandler: (Collection?, NSError?) -> Void) {
        
        let url = self.baseURL + "/collections/" + String(collectionID) + "/"
        
        Alamofire.request(.GET, url, headers: self.headers).validate().responseJSON{ response in
            switch response.result {
            case .Success:
                
                if let value = response.result.value {
                    let json = JSON(value)
                    let collection = Collection(fromJson: json)
                    completionHandler(collection, nil)
                } else {
                    // TODO: return custom NSError
                    completionHandler(nil, nil)
                }
                
            case .Failure(let error):
                
                print("Return error for \(url):\n\(error)")
                
            }
        }
    }
    
    
    private class func getObjectsAtPath(URL: String, completionHandler: ([AnyObject]?, NSError?) -> Void) {
        
        Alamofire.request(.GET, URL, headers: self.headers).validate().responseJSON { response in
            
            self.printResponse(response)
            
            switch response.result {
            case .Success:
                
                if let value = response.result.value {
                    let jsonObject = JSON(value)
                    
                    let resultsArray = jsonObject["results"].arrayValue
                    
                    var collections = [Collection]()
                    
                    for result in resultsArray {
                        let collection = Collection(fromJson: result)
                        collections.append(collection)
                    }
                    
                    if let label = self.label {
                        label.collections = collections
                    }
                    
                    completionHandler(collections, nil)
                } else {
                    // TODO: return custom NSError
                    completionHandler(nil, nil)
                }
                
            case .Failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    private class func getDetailAtPath
    
    private class func listObjects() {
        
    }
    
    private class func createObject() {
        
    }
    
    private class func retrieveObject() {
        
    }
    
    private class func updateObject() {
        
    }
    
    private class func deleteObject() {
        
    }
    //
    //    public class func getItems(url: String,  completionHandler: (AnyObject?, NSError?) -> Void) {
    //        let urlString = self.baseURL + appSlug + "/playlists/"
    //        self.debugPrint("Begin request for \(urlString).")
    //
    //        Alamofire.request(.GET, urlString).validate().responseJSON { response in
    //            switch response.result {
    //            case .Success:
    //
    //                if let value = response.result.value {
    //                    let json = JSON(value)
    //                    self.debugPrint("Recieved JSON for \(urlString):\n\(json)")
    //
    //                    if let mixtapes = self.createMixtapesFromJSON(json) {
    //                        completionHandler(mixtapes, nil)
    //                    } else {
    //                        // TODO: return custom NSError, unable to create Mixtapes from JSON
    //                        completionHandler(nil, nil)
    //                    }
    //                } else {
    //                    // TODO: return custom NSError
    //                    completionHandler(nil, nil)
    //                }
    //
    //            case .Failure(let error):
    //
    //                self.debugPrint("Return error for \(urlString):\n\(error)")
    //                completionHandler(nil, error)
    //
    //            }
    //        }
    //    }
    //
    //
    //    public class func getMixtapes(forCollection: Collection, completionHandler: ([Mixtape]?, NSError?) -> Void) {
    //        let urlString = self.baseURL + appSlug + "/playlists/"
    //        self.debugPrint("Begin request for \(urlString).")
    //
    //        Alamofire.request(.GET, urlString).validate().responseJSON { response in
    //            switch response.result {
    //            case .Success:
    //
    //                if let value = response.result.value {
    //                    let json = JSON(value)
    //                    self.debugPrint("Recieved JSON for \(urlString):\n\(json)")
    //
    //                    if let mixtapes = self.createMixtapesFromJSON(json) {
    //                        completionHandler(mixtapes, nil)
    //                    } else {
    //                        // TODO: return custom NSError, unable to create Mixtapes from JSON
    //                        completionHandler(nil, nil)
    //                    }
    //                } else {
    //                    // TODO: return custom NSError
    //                    completionHandler(nil, nil)
    //                }
    //
    //            case .Failure(let error):
    //
    //                self.debugPrint("Return error for \(urlString):\n\(error)")
    //                completionHandler(nil, error)
    //
    //            }
    //        }
    //    }
    //
    //    public class func getTracksforMixtape(mixtape: Mixtape, completionHandler: ([Track]?, NSError?) -> Void) {
    //        let mixtapeId = String(mixtape.id)
    //        let urlString = baseURL + appSlug + "/playlists/" + mixtapeId + "/tracks/?detail=true"
    //        self.debugPrint("Begin request for \(urlString).")
    //
    //        Alamofire.request(.GET, urlString).validate().responseJSON { response in
    //            switch response.result {
    //            case .Success:
    //
    //                if let value = response.result.value {
    //                    let json = JSON(value)
    //                    self.debugPrint("Recieved JSON for \(urlString):\n\(json)")
    //
    //                    if let tracks = self.createTracksFromJSON(json, forMixtape: mixtape) {
    //                        completionHandler(tracks, nil)
    //                    } else {
    //                        // TODO: return custom NSError, unable to create Tracks from JSON
    //                        completionHandler(nil, nil)
    //                    }
    //                } else {
    //                    // TODO: return custom NSError
    //                    completionHandler(nil, nil)
    //                }
    //
    //            case .Failure(let error):
    //
    //                self.debugPrint("Return error for \(urlString):\n\(error)")
    //                completionHandler(nil, error)
    //
    //            }
    //        }
    //    }
    //
    //    public class func postListenEventForMixtape(mixtape: Mixtape, track: Track, completionHandler: ((NSError?) -> Void)?) {
    //        let urlString = baseURL + "events/listen/"
    //        let parameters = [
    //            "playlist": String(mixtape.id),
    //            "track": String(track.id)
    //        ]
    //        self.debugPrint("Begin request for \(urlString).")
    //
    //        Alamofire.request(.POST, urlString, parameters: parameters).response { request, response, data, error in
    //            #if DEBUG
    //                if let value = response.result.value {
    //                    let json = JSON(value)
    //                    print("Recieved JSON for \(urlString):\n\(json)")
    //                } else {
    //                    print("Error for \(urlString):\n\(error)")
    //                }
    //            #endif
    //            if completionHandler != nil {
    //                completionHandler!(error)
    //            }
    //        }
    //    }
    //
    //    private class func createMixtapesFromJSON(json: JSON) -> [Mixtape]? {
    //        if json == nil || json.count == 0 {
    //            return nil
    //        }
    //
    //        let mixtapesJSON = json.arrayValue
    //        var mixtapes = [Mixtape]()
    //
    //        for mixtapeJSON in mixtapesJSON{
    //            let mixtape = Mixtape(fromJson: mixtapeJSON)
    //            mixtapes.append(mixtape)
    //        }
    //
    //        WhiteLabel.collection.mixtapes = mixtapes
    //
    //        return mixtapes
    //    }
    //
    //    private class func createTracksFromJSON(json: JSON, forMixtape mixtape: Mixtape) -> [Track]? {
    //        if json == nil || json.count == 0 {
    //            return nil
    //        }
    //
    //        let tracksJSON = json.arrayValue
    //        var tracks = [Track]()
    //
    //        for trackJSON in tracksJSON{
    //            let track = Track(fromJson: trackJSON, withSoundCloudToken: soundCloudToken)
    //            tracks.append(track)
    //        }
    //
    //        mixtape.tracks = tracks
    //
    //        return tracks
    //    }
    //
    private class func printResponse(response: Response<AnyObject, NSError>) {
        print("URL: \(response.request!.URL!)")
        for (key, value) in response.response!.allHeaderFields {
            print("\(key): \(value)")
        }
        print("Response:")
        print(response.result.value!)
    }
}



public class Request {
    
}




//enum Parameter {
//    case filter(String, AnyObject)
//    case search(String)
//    case order([OrderBy])
//}
//
//enum OrderBy: String {
//    case Name = "name"
//    case Title = "title"
//    case Artist = "artist"
//}
//
//public class ObjectMap {
//    let model: AnyClass
//    var map: [String: String]
//}
//
//
//Model = Collection
//endpoint = "/collections/"
//[
//    "id": "id",
//    "slug": "slug"
//]
//
//getCollectionList OrderBy.Title.Artist Search="noon" Filter.Collection="noon-178"
//
//getCollectionList OrderBy.Title.Artist Search="noon" Filter.Collection="noon-178"
//
//let order: [OrderBy] = [.UsesLineFragmentOrigin, .UsesFontLeading]
//
//Success [Collection]
//
//Failure NSError
