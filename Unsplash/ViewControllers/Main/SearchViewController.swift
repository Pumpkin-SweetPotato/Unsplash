//
//  SearchViewController.swift
//  Unsplash
//
//  Created by Minsoo Kim on 2020/11/17.
//

import UIKit

class SearchViewController: UIViewController {
    // @IBOutlet weak var rootView: UIView!
    // @IBOutlet weak var scrollView: UIScrollView!
    // @IBOutlet weak var scrollContentView: UIView!
    // @IBOutlet weak var topContainer: UIView!
    // @IBOutlet weak var topImageView: UIImageView!
    // @IBOutlet weak var appInfoButton: UIButton!
    // @IBOutlet weak var userInfoButton: UIButton!
    // @IBOutlet weak var keytakeawayLabel: UILabel!
    // @IBOutlet weak var searchBar: UISearchBar!
    // @IBOutlet weak var explorerContainer: UIView!
    // @IBOutlet weak var explorerCollectionView: UICollectionView!
    // @IBOutlet weak var newImagesContainer: UIView!
    // @IBOutlet weak var newImagesCollectionView: UICollectionView!

    private let rootView: UIView = UIView()
    private let scrollView: UIScrollView = UIScrollView()
    private let scrollContentView: UIView = UIView()
    
    //
    private let topContainer: UIView = {
        let topContainer = UIView()
        topContainer.backgroundColor = .red
        
        return topContainer
    }()
    
    private let topImageView: UIImageView = {
        let topImageView = UIImageView()
        
        return topImageView
    }()
    
    private let appInfoButton: UIButton = {
        let appInfoButton = UIButton()
        appInfoButton.setTitle("App", for: .normal)
        
        return appInfoButton
    }()
    
    private let userInfoButton: UIButton = {
        let userInfoButton = UIButton()
        userInfoButton.setTitle("User", for: .normal)
        
        return userInfoButton
    }()
    
    private let keytakeawayLabel: UILabel = {
        let keytakeawayLabel = UILabel()
        keytakeawayLabel.text = "Photos for everyone"
        keytakeawayLabel.textColor = .white
        keytakeawayLabel.font = .systemFont(ofSize: 26, weight: .bold)
        keytakeawayLabel.textAlignment = .center
        
        return keytakeawayLabel
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search photos"
//        searchBar.searchTextField.textColor = .white
//        searchBar.setImage(UIImage(systemName: "magnifyingglass"), for: .search, state: .normal)
        
        return searchBar
    }()
    
    private let artistNameLabel: UILabel = {
        let artistNameLabel = UILabel()
        artistNameLabel.font = .systemFont(ofSize: 9, weight: .light)
        artistNameLabel.textColor = .white
        artistNameLabel.text = "Photo by Aaron Burden"
        
        return artistNameLabel
    }()
    
    //
    private let explorerContainer: UIView = {
        let explorerContainer = UIView()
        explorerContainer.backgroundColor = .green
        
        return explorerContainer
    }()
    
    private let explorerLabel: UILabel = {
        let explorerLabel = UILabel()
        explorerLabel.text = "Explore"
        explorerLabel.textColor = .black
        explorerLabel.font = .systemFont(ofSize: 15)
        
        return explorerLabel
    }()
    
    private let explorerCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let explorerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        explorerCollectionView.register(ExplorerCollectionViewCell.self, forCellWithReuseIdentifier: ExplorerCollectionViewCell.reuseIdentifier)
        
        return explorerCollectionView
    }()
    
    private let newImagesContainer: UIView = {
        let newImagesContainer = UIView()
        newImagesContainer.backgroundColor = .gray
        
        return newImagesContainer
    }()
    
    private let newImageLabel: UILabel = {
        let newImageLabel = UILabel()
        newImageLabel.text = "New"
        newImageLabel.font = .systemFont(ofSize: 15)
        
        return newImageLabel
    }()
    
    private let newImagesCollectionView: UICollectionView = {
        let flowLayout = FlexibleHeightCollectionViewLayout()
        let newImagesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        newImagesCollectionView.register(NewImageCollectionViewCell.self, forCellWithReuseIdentifier: NewImageCollectionViewCell.reuseIdentifier)
        newImagesCollectionView.backgroundColor = .white
        
        return newImagesCollectionView
    }()
    
    var searchViewModel: SearchViewModel!
    private let leading: CGFloat = 15
    private let trailing: CGFloat = 15
    
    lazy var explorerCellSize: CGSize = CGSize(width: explorerCollectionView.bounds.size.width - leading * 2, height: 150)
    lazy var newImageCellSize: CGSize = CGSize(width: explorerCollectionView.bounds.size.width - leading * 2, height: 300)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        defer {
            searchViewModel = SearchViewModel()
            searchViewModel.searchViewOutput = self
            searchViewModel.viewDidLoad()
        }
        
        navigationController?.isNavigationBarHidden = true
        
        addViews()
        setConstraints()
        setDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }

    private func addViews() {
        view.addSubview(rootView)
        rootView.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        
        scrollContentView.addSubview(topContainer)

        topContainer.addSubview(topImageView)
        topContainer.addSubview(appInfoButton)
        topContainer.addSubview(userInfoButton)
        topContainer.addSubview(keytakeawayLabel)
        topContainer.addSubview(searchBar)

        scrollContentView.addSubview(explorerContainer)
        explorerContainer.addSubview(explorerLabel)
        explorerContainer.addSubview(explorerCollectionView)
        
        scrollContentView.addSubview(newImagesContainer)
        newImagesContainer.addSubview(newImageLabel)
        newImagesContainer.addSubview(newImagesCollectionView)
    }
    
    private func setConstraints() {
        rootView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rootView.topAnchor.constraint(equalTo: view.topAnchor),
            rootView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rootView.heightAnchor.constraint(equalTo: view.heightAnchor),
            rootView.widthAnchor.constraint(equalTo: view.widthAnchor),
            rootView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rootView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.contentInsetAdjustmentBehavior = .never
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: rootView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
            scrollView.heightAnchor.constraint(equalTo: rootView.heightAnchor),
            scrollView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor)
        ])
        
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        scrollContentView.backgroundColor = .brown
        
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        topContainer.backgroundColor = .cyan
//
        NSLayoutConstraint.activate([
            topContainer.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
            topContainer.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            topContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.43),
            topContainer.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            topContainer.widthAnchor.constraint(equalTo: scrollContentView.widthAnchor)
        ])

        topImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topImageView.topAnchor.constraint(equalTo: topContainer.topAnchor),
            topImageView.heightAnchor.constraint(equalTo: topContainer.heightAnchor),
            topImageView.widthAnchor.constraint(equalTo: topContainer.widthAnchor),
            topImageView.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor),
            topImageView.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor),
//            topImageView.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor),
        ])
        
        appInfoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appInfoButton.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: leading),
            appInfoButton.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 30),
            appInfoButton.widthAnchor.constraint(equalToConstant: 35),
            appInfoButton.heightAnchor.constraint(equalToConstant: 35),
        ])
        
        userInfoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userInfoButton.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: -trailing),
            userInfoButton.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 30),
            userInfoButton.widthAnchor.constraint(equalToConstant: 35),
            userInfoButton.heightAnchor.constraint(equalToConstant: 35),
        ])
        
        keytakeawayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            keytakeawayLabel.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor),
            keytakeawayLabel.widthAnchor.constraint(equalTo: topContainer.widthAnchor),
            keytakeawayLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 35),
            keytakeawayLabel.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: -10)
        ])
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.bottomAnchor.constraint(greaterThanOrEqualTo: topContainer.bottomAnchor, constant: -70),
            searchBar.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor),
            searchBar.widthAnchor.constraint(equalTo: topContainer.widthAnchor, constant:  -(leading + trailing)),
            
        ])
        
    

        explorerContainer.translatesAutoresizingMaskIntoConstraints = false
        explorerContainer.backgroundColor = .blue
        
        NSLayoutConstraint.activate([
            explorerContainer.topAnchor.constraint(equalTo: topContainer.bottomAnchor),
            explorerContainer.widthAnchor.constraint(equalTo: topContainer.widthAnchor),
            explorerContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
            explorerContainer.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            explorerContainer.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
        ])
        
        explorerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            explorerLabel.leadingAnchor.constraint(equalTo: explorerContainer.leadingAnchor, constant: leading),
            explorerLabel.topAnchor.constraint(equalTo: explorerContainer.topAnchor, constant: 15),
            explorerLabel.widthAnchor.constraint(lessThanOrEqualTo: explorerContainer.widthAnchor),
            explorerLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20)
        ])

        explorerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            explorerCollectionView.topAnchor.constraint(equalTo: explorerLabel.bottomAnchor),
            explorerCollectionView.heightAnchor.constraint(equalToConstant: 180),
            explorerCollectionView.widthAnchor.constraint(equalTo: explorerContainer.widthAnchor),
            explorerCollectionView.leadingAnchor.constraint(equalTo: explorerContainer.leadingAnchor),
            explorerCollectionView.trailingAnchor.constraint(equalTo: explorerContainer.trailingAnchor),
            explorerCollectionView.bottomAnchor.constraint(equalTo: explorerContainer.bottomAnchor),
        ])

        newImagesContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newImagesContainer.topAnchor.constraint(equalTo: explorerContainer.bottomAnchor),
            newImagesContainer.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            newImagesContainer.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            newImagesContainer.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor),
        ])
        
        newImageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newImageLabel.leadingAnchor.constraint(equalTo: explorerContainer.leadingAnchor, constant: leading),
            newImageLabel.topAnchor.constraint(equalTo: newImagesContainer.topAnchor, constant: 15),
            newImageLabel.widthAnchor.constraint(lessThanOrEqualTo: explorerContainer.widthAnchor),
            newImageLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20)
        ])

        newImagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newImagesCollectionView.topAnchor.constraint(equalTo: newImageLabel.bottomAnchor),
            newImagesCollectionView.leadingAnchor.constraint(equalTo: newImagesContainer.leadingAnchor),
            newImagesCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor),
            newImagesCollectionView.trailingAnchor.constraint(equalTo: newImagesContainer.trailingAnchor),
            newImagesCollectionView.bottomAnchor.constraint(equalTo: newImagesContainer.bottomAnchor),
        ])
        
        view.updateConstraintsIfNeeded()
    }

    private func setDelegates() {
        scrollView.delegate = self
        explorerCollectionView.delegate = self
        explorerCollectionView.dataSource = self
        newImagesCollectionView.delegate = self
        newImagesCollectionView.dataSource = self
        
        if let layout = newImagesCollectionView.collectionViewLayout as?  FlexibleHeightCollectionViewLayout {
            layout.delegate = self
        }
    }

}



extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
            case explorerCollectionView:
                break
            case newImagesCollectionView:
                let detailViewModel = DetailViewModel(photos: searchViewModel.currentState.newImagePhotos, selectedIndex: indexPath)

                let detailViewController = DetailViewController(detailViewModel: detailViewModel)
                
                detailViewController.modalPresentationStyle = .overFullScreen

                self.present(detailViewController, animated: true)
            default:
                break
        }
       
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case explorerCollectionView:
            return explorerCellSize
        case newImagesCollectionView:
            return newImageCellSize
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case explorerCollectionView:
            return searchViewModel.currentState.explorerPhotos.count
        case newImagesCollectionView:
            return searchViewModel.currentState.newImagePhotos.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case explorerCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExplorerCollectionViewCell.reuseIdentifier, for: indexPath)
                    as? ExplorerCollectionViewCell else { fatalError() }

            let photo = searchViewModel.currentState.explorerPhotos[indexPath.row]
            
            return cell
        case newImagesCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewImageCollectionViewCell.reuseIdentifier, for: indexPath)
                    as? NewImageCollectionViewCell else { fatalError() }
            
            let photo = searchViewModel.currentState.newImagePhotos[indexPath.row]
            
            cell.newImageCollectionViewCellModel = NewImageCollectionViewCellModel(photo: photo)
            
            return cell
        default:
            fatalError()
        }
    }
}

extension SearchViewController: SearchViewOutput {
    func needReloadNewImageCollectionView() {
        DispatchQueue.main.async {
            self.newImagesCollectionView.reloadData()
        }
    }

    func needReloadExplorerCollectionView() {
        DispatchQueue.main.async {
            self.explorerCollectionView.reloadData()
        }
    }

    func didImageItemAdded(indexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            self.newImagesCollectionView.insertItems(at: indexPaths)
        }
    }
}

extension SearchViewController: FlexibleHeightCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        let photo = searchViewModel.currentState.newImagePhotos[indexPath.row]
        let imageWidthRatio: CGFloat = collectionView.bounds.width / CGFloat(photo.width)
        let imageHeight: CGFloat = CGFloat(photo.height) * imageWidthRatio
        
        return imageHeight
    }
}

extension SearchViewController {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard velocity.y > 0 else { return }
        
        let height = scrollView.contentSize.height
        
        if height * 0.7 < velocity.y + targetContentOffset.pointee.y {
            searchViewModel.aboutToReachingBottom()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentY = scrollView.contentOffset.y

    }
}
