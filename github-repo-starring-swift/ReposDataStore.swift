//
//  ReposDataStore.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposDataStore {
    
    static let sharedInstance = ReposDataStore()
    fileprivate init() {}
    
    var repositories:[GithubRepository] = []
    
    func getRepositories(_ completion: @escaping () -> ()) {
        GithubAPIClient.getRepositories { (reposArray) in
            self.repositories.removeAll()
            for dictionary in reposArray {
                guard let repoDictionary = dictionary as? [String : Any] else { fatalError("Object in reposArray is of non-dictionary type") }
                let repository = GithubRepository(dictionary: repoDictionary)
                self.repositories.append(repository)
                
            }
            completion()
        }
    }
    
    func toggleStarStatus(for gitHubRepository: GithubRepository, starred: @escaping (Bool) -> Void) {
        
        GithubAPIClient.checkIfRepositoryIsStarred(fullName: gitHubRepository.fullName, completion: { isStarred in
            print("inside func")
            if isStarred == true {
                print("inside if statement")
                GithubAPIClient.unstarRepository(named: gitHubRepository.fullName) {
                    starred(false)
                }
            } else {
                GithubAPIClient.starRepository(named: gitHubRepository.fullName) {
                    print("went false")
                    starred(true)
                }
            }
            
        })
        
    }
    
}
