//
//  Main.swift
//  alabs
//
//  Created by ryan on 18.03.2022.
//

import UIKit

protocol ShowProtocol: class {
    func show(imageList: [Image])
    func show(videoList: [Video])
    func show(error: Error)
}

class MainVC: UIViewController {

    //let apiConverter = ApiConverterHelper()

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    var images: [Image] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    var videos: [Video] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    private var imageInteractor: ImageListBusinessLogic?
    private var imageRouter: ImageListRoutingLogic?

    private var videoInteractor: VideoListBusinessLogic?
    private var videoRouter: VideoListRoutingLogic?


    // MARK: Setup

    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        let imageInteractor = ImageListInteractor()
        let videoInteractor = VideoListInteractor()

        let imagePresenter = ImageListPresenter()
        let videoPresenter = VideoListPresenter()

        let imageRouter = ImageListRouter()
        let videoRouter = VideoListRouter()

        self.imageInteractor = imageInteractor
        self.imageRouter = imageRouter

        self.videoInteractor = videoInteractor
        self.videoRouter = videoRouter

        imageInteractor.presenter = imagePresenter
        videoInteractor.presenter = videoPresenter

        imagePresenter.viewController = self
        imageRouter.viewController = self
        videoPresenter.viewController = self
        videoRouter.viewController = self
    }

    // MARK: Lifecyles

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchbar()
        setupToHideKeyboardOnTapOnView()
        settings()

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(UINib(nibName: "ContentViewCell", bundle: nil), forCellWithReuseIdentifier: "ContentViewCell")

        title = "List"
    }


    func settings() {
        segmentControl.addTarget(self, action: #selector(segmentControlValueChanged), for: .valueChanged)
    }

    func setUpSearchbar() {
        searchBar.delegate = self
        searchBar.returnKeyType = .search
    }

    func setupToHideKeyboardOnTapOnView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func segmentControlValueChanged() {
        searchBar.text = ""
        collectionView.reloadData()
    }

//    func prepareForReuse() {
//
//        super.prepareForReuse()
//
//
//    }
}

extension MainVC: ShowProtocol {

    func show(imageList: [Image]) {
        images = imageList
    }

    func show(videoList: [Video]) {
        videos = videoList
    }

    func show(error: Error) {
        print(error)
    }
}

extension MainVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        var offset = collectionView.contentOffset
        let height = collectionView.contentSize.height
        if offset.y < height/4 {
            offset.y += height/2
            collectionView.setContentOffset(offset, animated: false)
        } else if offset.y > height/4 * 3 {
            offset.y -= height/2
            collectionView.setContentOffset(offset, animated: false)
        }
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.reloadData()

        if segmentControl.selectedSegmentIndex == 0 {
            return images.count*2
        } else {
            return videos.count*2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = self.collectionView.frame.width
        return CGSize(width: (collectionViewWidth - 20)/2, height: 100)
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentViewCell", for: indexPath) as! ContentViewCell
        if segmentControl.selectedSegmentIndex == 0 {
            var index = indexPath.item
            if index > images.count - 1 {
                index -= images.count
            }
            cell.contentImage.load(url: images[index % images.count].previewURL)

        } else {
            var index = indexPath.item
            if index > videos.count - 1 {
                index -= videos.count
            }
            let urlPhoto = apiConverter.creatVideoPictureLink(photoID: videos[index % videos.count].picture_id)
            cell.contentImage.load(url: urlPhoto)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if segmentControl.selectedSegmentIndex == 0 {
            let image = images[indexPath.row]
            imageRouter?.show(image)
        } else {
            let video = videos[indexPath.row].videos.medium.url
            videoRouter?.show(video)
        }
    }
}

extension MainVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if segmentControl.selectedSegmentIndex == 0 {
            imageInteractor?.fetchImageList(request: ImageListRequest(searchTerm: searchBar.text ?? " "))
        }
        else {
            videoInteractor?.fetchVideoList(request: VideoListRequest(searchTerm: searchBar.text ?? " "))
        }
    }
}


extension UIImageView {
    func load(url: String) {
        let urlFind = URL(string: url) ?? URL(string: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fsecretmag.ru%2Fstories%2Frossiiskii-drift-kak-khuliganskie-gonki-stali-bolshim-biznesom.htm&psig=AOvVaw0kp7MnDb71HDXGb8nfNLJ8&ust=1647741807196000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCMil3tuK0fYCFQAAAAAdAAAAABAD")

        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: urlFind!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
