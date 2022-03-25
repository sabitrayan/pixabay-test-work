//
//  Video.swift
//  alabs
//
//  Created by ryan on 19.03.2022.
//

import Foundation

struct VideosSize: Decodable {
    var url: String
    var width: Int
    var height: Int
    var size: Int
}

struct VideoQuailty: Decodable {
    var large: VideosSize
    var small: VideosSize
    var medium: VideosSize
    var tiny: VideosSize
}

struct Video: Decodable {
    var id: Int
    var pageURL: String
    var type: String
    var tags: String
    var duration: Int
    var picture_id: String
    var videos: VideoQuailty
    var views: Int
    var downloads: Int
    var likes: Int
    var comments: Int
    var user_id: Int
    var user: String
    var userImageURL: String
}

struct GetVideosStruct: Decodable {
    var total: Int
    var totalHits: Int
    var hits: [Video]
}
