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
    
    private func configureSelf() {
        navigationItem.title = "Top Albums"
        view.backgroundColor = .white
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TopAlbumCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
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
}

// MARK: - UITableViewDataSource
extension TopAlbumsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let album = albums[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TopAlbumCollectionViewCell
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

extension TopAlbumsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.45, height: view.frame.height * 0.3)
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
