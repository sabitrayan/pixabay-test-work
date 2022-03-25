//
//  ImageListRouter.swift
//  alabs
//
//  Created by ryan on 18.03.2022.
//

import UIKit

protocol ImageListRoutingLogic {
    func show(_ image: Image)
}

class ImageListRouter: ImageListRoutingLogic {
    weak var viewController: MainVC?

    func show(_ image: Image) {
        let imageDetailViewController = ImageDetailViewController(image: image)
        viewController?.present(imageDetailViewController, animated: true)
    }

}

