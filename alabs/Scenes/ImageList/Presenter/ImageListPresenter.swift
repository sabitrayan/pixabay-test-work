//
//  ImageListPresenter.swift
//  alabs
//
//  Created by ryan on 18.03.2022.
//

import Foundation

protocol ImageListPresentationLogic {
    func show(imageList: ImageListResponse)
    func show(error: Error)
}

class ImageListPresenter: ImageListPresentationLogic {

    weak var viewController: ShowProtocol?

    func show(imageList: ImageListResponse) {
        viewController?.show(imageList: imageList.hits)
    }

    func show(error: Error) {
        viewController?.show(error: error)
    }
}
