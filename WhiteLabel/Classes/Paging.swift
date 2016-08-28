//
//  Paging.swift
//
//  Based on code by by Marcin Krzyzanowski on 22/06/15.
//  Copyright (c) 2015 Marcin Krzyżanowski. All rights reserved.
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

public protocol AsyncGeneratorType {
    associatedtype Fetch
    mutating func getNext(complete: (() -> Void)?)
}

public class PagingGenerator: AsyncGeneratorType {
    public typealias Fetch = (page: UInt) -> Void
    
    public var next:Fetch!
    private(set) var page: UInt
    private(set) var startPage: UInt
    public var didReachEnd: Bool = false
    
    public init(startPage: UInt = 1) {
        self.startPage = startPage
        self.page = startPage
    }
    
    public func getNext(complete: (() -> Void)? = nil) {
        if didReachEnd { return }
        next(page: page)
        if complete != nil {
            complete!()
        }
        self.page += 1
    }
    
    public func reachedEnd() {
        didReachEnd = true
    }
    
    public func reset() {
        didReachEnd = false
        page = startPage
    }
}
