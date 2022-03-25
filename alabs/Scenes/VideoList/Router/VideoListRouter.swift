//
//  VideoListRouter.swift
//  alabs
//
//  Created by ryan on 19.03.2022.
//

import Foundation

protocol VideoListRoutingLogic {
    func show(_ url: String)
}

class VideoListRouter: VideoListRoutingLogic {
    weak var viewController: MainVC?

    func show(_ url: String) {
        let videoDetailViewController = VideoDetailViewController()
        videoDetailViewController.websiteURL = url
        viewController?.present(videoDetailViewController, animated: true)
    }

}


