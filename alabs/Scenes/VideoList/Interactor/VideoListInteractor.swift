//
//  VideoListInteractor.swift
//  alabs
//
//  Created by ryan on 19.03.2022.
//

import Foundation
import UIKit

protocol VideoListBusinessLogic {
    func fetchVideoList(request: VideoListRequest)
}

class VideoListInteractor: VideoListBusinessLogic {

    var presenter: VideoListPresentationLogic?
    var videoListWorker = VideoListWorker()
    var videos: [Video]?

    func fetchVideoList(request: VideoListRequest) {
//        guard let videos = VideoListWorker.fetchVideo(request.searchTerm), let error = Error else { return self.presenter?.show(error: error) }
        //var result = videoListWorker.fetchVideo(searchText: request.searchTerm)
       // presenter?.show(videoList: result)


        videoListWorker.fetch(searchText: request.searchTerm).done { response in
            self.presenter?.show(videoList: response)
        }.catch { error in
            self.presenter?.show(error: error)
        }
    }
}

