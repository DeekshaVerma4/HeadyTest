//
//  NetworkHelper.swift
//  HeadyTest
//
//  Created by Deeksha on 3/7/19.
//  Copyright © 2019 Deeksha. All rights reserved.
//

import Foundation

/// Network Helper Class
class NetworkHelper {
    /// Create Instance for Network Helper
    static var instance: NetworkHelper? = nil
    /// URL Session
    var session = URLSession.shared
    
    /// Get Instance for Network Helper
    /// - Returns: instance
    public static  func getInstance() -> NetworkHelper{
        if instance == nil {
            instance = NetworkHelper()
        }
        return instance!
    }
    
    /// This method is used for GET request.
    /// - Parameters:
    ///   - url: URL to be used
    ///   - callBack: callback after GET
    func getRequest(url:String,callBack:@escaping (_ data:Data?,_ error:Error?)->(Void)) {
        var request = URLRequest(url: URL(string: url)!)
        var session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 5
        session = URLSession(configuration: URLSessionConfiguration.default)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            callBack(data,error)
        }
        dataTask.resume()
    }
}
