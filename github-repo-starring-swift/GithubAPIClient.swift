//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GithubAPIClient {
    
    class func getRepositories(_ completion: @escaping ([Any]) -> ()) {
        let urlString = "\(Constants.githubAPIURL)/repositories?client_id=\(Constants.githubClientID)&client_secret=\(Constants.githubClientSecret)"
        let url = URL(string: urlString)
        let session = URLSession.shared
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        
        let task = session.dataTask(with: unwrappedURL, completionHandler: { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        })
        task.resume()
    }
    
    class func checkIfRepositoryIsStarred(fullName: String, completion: @escaping (Bool) -> ()) {
        
        let urlString = "https://api.github.com/user/starred/\(fullName)?access_token=\(Constants.access_token)"
        let url = URL(string: urlString)
        let session = URLSession.shared
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        var request = URLRequest(url: unwrappedURL)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            let httpResponse = response as! HTTPURLResponse
            
//            switch httpResponse.statusCode{
//            case 200..<299:
//                break
//            case 300..<399:
//                break
//                
//            }

            if httpResponse.statusCode == 204 {
                completion(true)
            } else if httpResponse.statusCode == 404 {
                completion(false)
            }
        }
        
        task.resume()
    }
    
    class func starRepository(named: String, completion:@escaping () -> Void) {
        let urlString = "\(Constants.githubAPIURL)/user/starred/\(named)?access_token=\(Constants.access_token)"

        let url = URL(string: urlString)
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        var request = URLRequest(url: unwrappedURL)
        request.addValue("0", forHTTPHeaderField: "Content-Length")
        request.httpMethod = "PUT"        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            completion()
        }
        
        task.resume()
        
        
    }
    
    class func unstarRepository(named: String, completion:@escaping () -> Void) {
        let urlString = "\(Constants.githubAPIURL)/user/starred/\(named)?access_token=\(Constants.access_token)"
        let url = URL(string: urlString)
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        var request = URLRequest(url: unwrappedURL)
        request.httpMethod = "DELETE"
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            completion()
        }
        
        task.resume()
    }
}


