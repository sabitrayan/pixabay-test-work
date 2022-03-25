//
//  VideoListPresenter.swift
//  alabs
//
//  Created by ryan on 19.03.2022.
//

import Foundation

protocol VideoListPresentationLogic {
    func show(videoList: VideoListResponse)
    func show(error: Error)
}

class VideoListPresenter: VideoListPresentationLogic {

    weak var viewController: ShowProtocol?

    func show(videoList: VideoListResponse) {
        viewController?.show(videoList: videoList.hits)
//        print(videoList.hits)
    }

    func show(error: Error) {
        viewController?.show(error: error)
    }
}
