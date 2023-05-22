//
//  RedditEntriesService.swift
//  TopRedditEntries
//
//  Created by Germano Rojas on 21/5/23.
//

import Foundation

class RedditEntriesService {
    func getEntries(request: ListingRequest, completion: @escaping (Result<(posts: [Post]?, after: String?), Error>) -> Void) {
        NetworkService.share.request(endpoint: EntriesEndpoints.getTopEntries(count: request.count, after: request.after), decodeType: Listing.self) { result in
            switch result {
            case .success(let response):
                completion(.success((response?.posts, response?.after)))
            
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
}
