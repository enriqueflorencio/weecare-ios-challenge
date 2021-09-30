//
//  TopAlbumsViewController.swift
//  weecare-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import UIKit

final class TopAlbumsViewController: UIViewController {
    
    private let cache = NSCache<NSString, UIImage>()
    private let iTunesAPI: ITunesAPI
    private let networking: Networking
    private let collectionView = UICollectionView(
        frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()
    )
    private let reuseIdentifier = "TopAlbumCollectionViewCell"
    private var albums = [Album]() {
        didSet {
            collectionView.reloadData()
        }
    }
    private let weeCareGradientLayer = CAGradientLayer()
    private var currentSortingIndex: Int?
    
    init(iTunesAPI: ITunesAPI, networking: Networking) {
        self.iTunesAPI = iTunesAPI
        self.networking = networking
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelf()
        configureCollectionView()
        loadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        weeCareGradientLayer.frame = view.layer.bounds
    }
    
    private func configureSelf() {
        navigationItem.title = "Top Albums"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(filter))
        
        weeCareGradientLayer.frame = view.bounds
        weeCareGradientLayer.colors = [UIColor(red: 138/255, green: 148/255, blue: 243/255, alpha: 1).cgColor, UIColor(red: 191/255, green: 227/255, blue: 229/255, alpha: 1).cgColor]
        weeCareGradientLayer.shouldRasterize = true
        view.layer.addSublayer(weeCareGradientLayer)
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TopAlbumCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func loadData() {
        iTunesAPI.getTopAlbums(limit: 10) { [weak self] res in
            switch res {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.albums = data.feed.results
                }
            case .failure(let err):
                debugPrint(err)
            }
        }
    }
    
    private func downloadImage(url: String, completion: @escaping (Result<UIImage?, Error>) -> ()) {
        let request = APIRequest(url: url)
        networking.requestData(request) { res in
            completion(res.map { data in UIImage(data: data) })
        }
    }
    
    @objc private func filter() {
        if view.viewWithTag(-1) == nil {
            let sortView = SortView()
            if let sortingIndex = currentSortingIndex {
                sortView.setSortingIndex(sortingIndex: sortingIndex)
            }
            sortView.delegate = self
            sortView.tag = -1
            view.addSubview(sortView)
        }
    }
}

//MARK: Sort View Delegate Functions
extension TopAlbumsViewController: SortViewDelegate {
    public func didTapCategory(category: Int) {
        currentSortingIndex = category
        switch category {
        case 0: //Album title
            albums.sort(by: {$0.name.lowercased() < $1.name.lowercased()})
            collectionView.reloadData()
        case 1: //Artist name
            albums.sort(by: {$0.artistName.lowercased() < $1.artistName.lowercased()})
            collectionView.reloadData()
        case 2: //Release Date
            albums.sort(by: {$0.releaseDate.compare($1.releaseDate) == .orderedDescending})
            collectionView.reloadData()
        default:
            break
        }
    }
}

// MARK: - UICollectionViewDataSource
extension TopAlbumsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let fallbackCell = UICollectionViewCell()
        let album = albums[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? TopAlbumCollectionViewCell else {return fallbackCell}
        cell.albumLabel.text = album.name
        cell.artistNameLabel.text = album.artistName
        
        if let imageURL = album.artworkUrl100 {
            if let img = cache.object(forKey: album.id as NSString) {
                cell.albumImageView.image = img
            } else {
                downloadImage(url: imageURL) { [weak self, weak cell] res in
                    switch res {
                    case .success(let img):
                        guard let img = img else { return }
                        self?.cache.setObject(img, forKey: album.id as NSString)
                        DispatchQueue.main.async {
                            cell?.albumImageView.image = img
                        }
                    case .failure(let err):
                        debugPrint(err)
                    }
                }
            }
        }
        
        return cell
    }
    
}

// MARK: -UICollectionViewDelegateFlowLayout
extension TopAlbumsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight) {
            return CGSize(width: (collectionView.frame.size.width-80) / 3, height: (collectionView.frame.size.width-160) / 3)
        } else {
            return CGSize(width: (collectionView.frame.size.width-30) / 2, height: (collectionView.frame.size.width-30) / 2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

}