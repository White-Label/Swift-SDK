//
//  Constants.swift
//  Pods
//
//  Created by Alexander Givens on 10/3/16.
//
//

import Foundation

public enum Constants {
    public static let BaseURLString: String = "https://beta.whitelabel.cool/api"
    public static var Version: String = "1.0"
    public static let ErrorDomain: String = "cool.whitelabel.swift"
    public static var PageSize: UInt = 20
    public static var ClientID: String?
}

public enum BackendError: ErrorType {
    case Network(statusCode: Int, error: NSError)
    case JSONSerialization(error: NSError)
    case ObjectSerialization(reason: String)
}
