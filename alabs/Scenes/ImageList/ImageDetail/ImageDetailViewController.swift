//
//  ImageDetailViewController.swift
//  alabs
//
//  Created by ryan on 18.03.2022.
//

import UIKit

class ImageDetailViewController: UIViewController {

    // MARK: Properties

    @IBOutlet weak var imageView: UIImageView!

    private let image: Image

    // MARK: Initialization

    init(image: Image) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecyles

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Detail"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let url = URL(string: image.largeImageURL) else { return }


        imageView.load(url: "\(url)")
    }

}
