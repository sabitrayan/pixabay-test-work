//
//  ImageListModel.swift
//  alabs
//
//  Created by ryan on 18.03.2022.
//

import Foundation

struct ImageListRequest {
    var searchTerm: String
}

struct ImageListResponse: Decodable {
    var total: Int
    var totalHits: Int
    var hits: [Image]
}

class ApiConverterHelper {
    private let apiKey = "26148166-30481031653dcb2acfb623024"
    private let questions = "&q="
    private let pixabayAPIPhoto = "https://pixabay.com/api/?key="
    private let pixabayAPIVideo = "https://pixabay.com/api/videos/?key="
    private let imageType = "&image_type=photo"

    func getUrlAdress(photoName: String) -> String {
        let photoNameInHttp = stringSpaceToPlus(string: photoName)
        let urlString = pixabayAPIPhoto + apiKey + questions + photoNameInHttp + imageType
        return urlString
    }

    func getUrlVideo(photoName: String) -> String {
        let photoNameInHttp = stringSpaceToPlus(string: photoName)
        let urlString = pixabayAPIVideo + apiKey + questions + photoNameInHttp
        return urlString
    }

    func stringSpaceToPlus(string: String) -> String {
        var characters = Array(string)
        let spaceCharacter: Character = " "
        let plusCharacter: Character = "+"
        for index in 0 ..< characters.count {
            if characters[index] == spaceCharacter {
                characters[index] = plusCharacter
            }
        }
        return String(characters)
    }

    func creatVideoPictureLink(photoID: String) -> String {
        let imagesSite = "https://i.vimeocdn.com/video/"
        let imageDataType = ".jpg"
        return imagesSite + photoID + imageDataType
    }
}
