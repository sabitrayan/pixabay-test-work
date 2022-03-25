//
//  ImageListInteractor.swift
//  alabs
//
//  Created by ryan on 18.03.2022.
//

import UIKit

protocol ImageListBusinessLogic {
    func fetchImageList(request: ImageListRequest)
}

class ImageListInteractor: ImageListBusinessLogic {
    var presenter: ImageListPresentationLogic?
    var imageListWorker = ImageListWorker()
    var images: [Image]?

    func fetchImageList(request: ImageListRequest) {
        imageListWorker.fetch(searchTerm: request.searchTerm).done { response in
            self.presenter?.show(imageList: response)
        }.catch { error in
            self.presenter?.show(error: error)
        }
    }
}

