//
//  ImageListWorker.swift
//  alabs
//
//  Created by ryan on 19.03.2022.
//

import PromiseKit
import UIKit

class ImageListWorker {

    //let apiConverter = ApiConverterHelper()
//    var result: [Image] = []
//    func x(searchText: String, images: [Image] ) -> [Image]{
//        DispatchQueue.global(qos: .utility).async { [self] in
//            guard let url = URL(string: apiConverter.getUrlAdress(photoName: searchText)) else { return }
//            URLSession.shared.dataTask(with: url) { data, responce, error in
//                guard let data = data else { return }
//                do {
//                    let jsonFile = try JSONDecoder().decode(GetImagesStruct.self, from: data)
//                    result = jsonFile.hits
//
//                } catch let error {
//                    print(error)
//                }
//            }.resume()
//        }
//        return result
//    }

    func fetch(searchTerm: String) -> Promise<ImageListResponse> {
        let urlString = "https://pixabay.com/api/?key=26148166-30481031653dcb2acfb623024&q=\(searchTerm)&image_type=photo&pretty=true"
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
                    let decoder = JSONDecoder()
                    let imageData = try decoder.decode(
                        ImageListResponse.self, from: data)
                    resolver.resolve(.fulfilled(imageData))
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

enum ServiceNetworkError: Error {
    case noData
    case httpError(_ error: Error)
}

enum ServiceParsingError: Error {
    case dataCorrupted
    case keyNotFound
    case valueNotFound
    case typeMismatch
    case generalError(_ error: Error)
}
