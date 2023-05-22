//
//  Listing.swift
//  TopRedditEntries
//
//  Created by Germano Rojas on 21/5/23.
//

import Foundation

struct ListingRequest: Codable {
    let count: String
    let after: String
    
    init(count: String, after: String) {
        self.count = count
        self.after = after
    }
}

struct ListingChildrenModel: Codable {
    var post: Post
    
    enum CodingKeys: String, CodingKey {
        case post = "data"
    }
}

struct Listing: Codable {
    var children: [ListingChildrenModel]
    var after: String
    
    enum CodingKeys: String, CodingKey {
        case children
        case after
    }
    
    var posts: [Post] {
        return children.map { $0.post }
    }
}
