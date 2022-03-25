//
//  Image.swift
//  alabs
//
//  Created by ryan on 18.03.2022.
//

import Foundation

struct Image: Decodable {
    var id: Int
    var largeImageURL: String
    var previewURL: String
}
