//
//  VideoListModel.swift
//  alabs
//
//  Created by ryan on 19.03.2022.
//

import Foundation

struct VideoListRequest {
    var searchTerm: String
}

struct VideoListResponse: Decodable {
    var total: Int
    var totalHits: Int
    var hits: [Video]
}
