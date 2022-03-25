//
//  VideoListWorker.swift
//  alabs
//
//  Created by ryan on 19.03.2022.
//

import Foundation
import PromiseKit

public enum Result<T, U> {
    case success(T)
    case failure(U)
}

class VideoListWorker {
    static func fetchVideo(searchText: String,completion: @escaping (Result<VideoListResponse, Error>) -> () ) {

        let apiConverter = ApiConverterHelper()

        DispatchQueue.global(qos: .utility).async {
            guard let url = URL(string: apiConverter.getUrlVideo(photoName: searchText)) else { return }
            URLSession.shared.dataTask(with: url) { data, responce, error in
                guard let data = data else { return }
                do {
                    let jsonFile = try JSONDecoder().decode(VideoListResponse.self, from: data)

                } catch let error {
                    print(error)
                }
            }.resume()
        }
    }

    func fetch(searchText: String) -> Promise<VideoListResponse> {
        //let urlString = URL(string: apiConverter.getUrlVideo(photoName: searchText))

        let urlString = "https://pixabay.com/api/videos/?key=26148166-30481031653dcb2acfb623024&q=\(searchText)"
        let url = URL(string: urlString)!
        return Promise { resolver in
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard error == nil else {
                    resolver.reject(ServiceNetworkError.httpError(error!))
                    return
                }
               
                guard let data = data else {
                    resolver.reject(ServiceNetworkError.noData)
                    return
                }

                do {
                    let videoData = try JSONDecoder().decode(VideoListResponse.self, from: data)
                    resolver.resolve(.fulfilled(videoData))
                } catch let DecodingError.dataCorrupted(context) {
                    print(context.debugDescription)
                    resolver.reject(ServiceParsingError.dataCorrupted)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found: \(context.debugDescription)")
                    print("codingPath: \(context.codingPath)")
                    resolver.reject(ServiceParsingError.keyNotFound)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found: \(context.debugDescription)")
                    print("codingPath: \(context.codingPath)")
                    resolver.reject(ServiceParsingError.valueNotFound)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch: \(context.debugDescription)")
                    print("codingPath: \(context.codingPath)")
                    resolver.reject(ServiceParsingError.typeMismatch)
                } catch {
                    print("error: \(error)")
                    resolver.reject(ServiceParsingError.generalError(error))
                }
                }.resume()
        }
    }
}
