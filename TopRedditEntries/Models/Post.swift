//
//  Post.swift
//  TopRedditEntries
//
//  Created by Germano Rojas on 21/5/23.
//

import Foundation

struct Post: Codable {
    var id: String
    var title: String
    var author: String
    var url: String
    var thumbnail: String
    var created: Double
    var numComments: Int
    var subreddit: String
    var date: String {
        let epochToDate = NSDate(timeIntervalSince1970: created)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: epochToDate as Date)
    }
    var subredditNamePrefixed: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case author
        case url
        case thumbnail
        case created
        case numComments = "num_comments"
        case subreddit
        case subredditNamePrefixed = "subreddit_name_prefixed"
    }
}
