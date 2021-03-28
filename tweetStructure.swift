//
//  tweetStructure.swift
//  TweetCSVAnnotator
//
//  Created by Logan Lane on 3/3/21.
//

import Foundation

struct Tweet : Codable {
    var tweet : String
    var `Type` : Bool
    
}
private enum CodingKeys: String, CodingKey {
    case tweet = "tweet"
    case `Type` = "Type"
    }
