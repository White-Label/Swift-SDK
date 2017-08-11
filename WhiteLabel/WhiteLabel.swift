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
import CoreData

// MARK: Label

public func GetLabel(complete: @escaping (Result<WLLabel>) -> Void) {
    Alamofire.request(Router.getLabel).validate().responseObject { (response: DataResponse<WLLabel>) in
        complete(response.result)
    }
}

// MARK: Collections

public func GetCollection(id: Any, complete: @escaping (Result<WLCollection>) -> Void) {
    
    var identifier = id
    if let collection = id as? WLCollection {
        identifier = collection.id
    }
    
    Alamofire.request(Router.getCollection(id: identifier)).validate().responseObject { (response: DataResponse<WLCollection>) in
        complete(response.result)
    }
}

public func ListCollections(
    parameters: Parameters? = nil,
    page: Int = 1,
    pageSize: Int = Constants.PageSize,
    complete: @escaping (_ result: Result<[WLCollection]>, _ total: Int) -> Void)
{
    var params = parameters ?? Parameters()
    params["page"] = page
    params["page_size"] = pageSize
    
    Alamofire.request(Router.listCollections(parameters: params)).validate().responseCollection { (response: DataResponse<[WLCollection]>) in
        let totalCount = (response.response?.allHeaderFields["Count"] as? NSString)?.integerValue ?? 0
        if response.result.value != nil {
            do {
                try CoreDataStack.sharedStack.managedObjectContext.save()
            } catch let error as NSError {
                print("Core Data error: \(error.userInfo)")
            }
        }
        complete(response.result, totalCount)
    }
}

// MARK: Mixtapes

public func GetMixtape(id: Any, complete: @escaping (Result<WLMixtape>) -> Void) {
    
    var identifier = id
    if let mixtape = id as? WLMixtape {
        identifier = mixtape.id
    }
    
    Alamofire.request(Router.getMixtape(id: identifier)).validate().responseObject { (response: DataResponse<WLMixtape>) in
        complete(response.result)
    }
}

public func ListMixtapes(
    inCollection collection: WLCollection? = nil,
    parameters: Parameters? = nil,
    page: Int = 1,
    pageSize: Int = Constants.PageSize,
    complete: @escaping (_ result: Result<[WLMixtape]>, _ total: Int) -> Void)
{
    var params = parameters ?? Parameters()
    if collection != nil {
        params["collection"] = collection!.id
    }
    params["page"] = page
    params["page_size"] = pageSize
    
    Alamofire.request(Router.listMixtapes(parameters: params)).validate().responseCollection { (response: DataResponse<[WLMixtape]>) in
        let totalCount = (response.response?.allHeaderFields["Count"] as? NSString)?.integerValue ?? 0
        if response.result.value != nil {
            do {
                try CoreDataStack.sharedStack.managedObjectContext.save()
            } catch let error as NSError {
                print("Core Data error: \(error.localizedDescription)")
            }
        }
        complete(response.result, totalCount)
    }
}

// MARK: Tracks

public func GetTrack(id: Any, complete: @escaping (Result<WLTrack>) -> Void) {
    
    var identifier = id
    if let track = id as? WLTrack {
        identifier = track.id
    }
    
    Alamofire.request(Router.getTrack(id: identifier)).validate().responseObject { (response: DataResponse<WLTrack>) in
        complete(response.result)
    }
}

public func ListTracks(
    inMixtape mixtape: WLMixtape? = nil,
    parameters: Parameters? = nil,
    page: Int = 1,
    pageSize: Int = Constants.PageSize,
    complete: @escaping (_ result: Result<[WLTrack]>, _ total: Int) -> Void)
{
    var params = parameters ?? Parameters()
    if mixtape != nil {
        params["mixtape"] = mixtape!.id
    }
    params["page"] = page
    params["page_size"] = pageSize
    
    Alamofire.request(Router.listTracks(parameters: params)).validate().responseCollection { (response: DataResponse<[WLTrack]>) in
        let totalCount = (response.response?.allHeaderFields["Count"] as? NSString)?.integerValue ?? 0
        if response.result.value != nil {
            do {
                try CoreDataStack.sharedStack.managedObjectContext.save()
            } catch let error as NSError {
                print("Core Data error: \(error.localizedDescription)")
            }
        }
        complete(response.result, totalCount)
    }
}

