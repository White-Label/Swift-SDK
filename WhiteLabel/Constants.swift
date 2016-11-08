//
//  Constants.swift
//  Pods
//
//  Created by Alexander Givens on 9/29/16.
//
//

import Foundation

public enum Constants {
    public static let BaseURLString: String = "https://beta.whitelabel.cool/api"
    public static var Version: String = "1.0"
    public static let ErrorDomain: String = "cool.whitelabel.swift"
    public static var PageSize: UInt = 20
    public static var ClientID = ""
}

public enum BackendError: Error {
    case network(error: Error) // Capture any underlying Error from the URLSession API
    case dataSerialization(error: Error)
    case jsonSerialization(error: Error)
    case xmlSerialization(error: Error)
    case objectSerialization(reason: String)
}
