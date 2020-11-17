//
//  SearchViewController.swift
//  Unsplash
//
//  Created by eazel7 on 2020/11/17.
//

import UIKit

class SearchViewController: UIViewController {
    let rootView: UIView = UIView()
    let scrollView: UIScrollView = UIScrollView()
    let scrollContentView: UIView = UIView()
    
    //
    let topContainer: UIView = {
        let topContainer = UIView()
        topContainer.backgroundColor = .red
        
        return topContainer
    }()
    
    let topImageView: UIImageView = {
        let topImageView = UIImageView()
        
        return topImageView
    }()
    
    let appInfoButton: UIButton = {
        let appInfoButton = UIButton()
        appInfoButton.setTitle("App", for: .normal)
        
        return appInfoButton
    }()
    
    let userInfoButton: UIButton = {
        let userInfoButton = UIButton()
        userInfoButton.setTitle("User", for: .normal)
        
        return userInfoButton
    }()
    
    let keytakeawayLabel: UILabel = {
        let keytakeawayLabel = UILabel()
        keytakeawayLabel.text = "Photos for everyone"
        
        return keytakeawayLabel
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search photos"
        searchBar.setImage(UIImage(systemName: "magnifyingglass"), for: .search, state: .normal)
        
        return searchBar
    }()
    //
    
    //
    let explorerContainer: UIView = {
        let explorerContainer = UIView()
        explorerContainer.backgroundColor = .green
        
        return explorerContainer
    }()
    let explorerCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let explorerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        explorerCollectionView.register(ExplorerCollectionViewCell.self, forCellWithReuseIdentifier: ExplorerCollectionViewCell.reuseIdentifier)
        
        return explorerCollectionView
    }()
    //
    let newImagesContainer: UIView = {
        let newImagesContainer = UIView()
        newImagesContainer.backgroundColor = .gray
        
        return newImagesContainer
    }()
    
    let newImagesCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let newImagesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        newImagesCollectionView.register(NewImageCollectionViewCell.self, forCellWithReuseIdentifier: NewImageCollectionViewCell.reuseIdentifier)
        
        return newImagesCollectionView
    }()
    
    var searchViewModel: SearchViewModel!
    let leading: CGFloat = 15
    
    lazy var explorerCellSize: CGSize = CGSize(width: explorerCollectionView.bounds.size.width - leading * 2, height: 150)
    lazy var newImageCellSize: CGSize = CGSize(width: explorerCollectionView.bounds.size.width - leading * 2, height: 300)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        defer {
            searchViewModel = SearchViewModel(searchViewOutput: self)
            searchViewModel.viewDidLoad()
        }
        
        navigationController?.isNavigationBarHidden = true
        
        addViews()
        setConstraints()
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
        explorerContainer.addSubview(explorerCollectionView)
        
        scrollContentView.addSubview(newImagesContainer)
        newImagesContainer.addSubview(newImagesCollectionView)
    }
    
    private func setConstraints() {
        rootView.translatesAutoresizingMaskIntoConstraints = false
        rootView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        rootView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        rootView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        rootView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        rootView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        rootView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.topAnchor.constraint(equalTo: rootView.topAnchor).isActive = true
//        scrollView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor).isActive = true
//        scrollView.heightAnchor.constraint(equalTo: rootView.heightAnchor).isActive = true
//        scrollView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor).isActive = true
//        scrollView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor).isActive = true
//        scrollView.backgroundColor = .blue

//        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
//        scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
//        scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
//        scrollContentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
//        scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
//        scrollContentView.backgroundColor = .brown
        
//        topContainer.translatesAutoresizingMaskIntoConstraints = false
//        topContainer.topAnchor.constraint(equalTo: scrollContentView.topAnchor).isActive = true
//        topContainer.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor).isActive = true
//        topContainer.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor).isActive = true
//
//
//        topImageView.translatesAutoresizingMaskIntoConstraints = false
//        topImageView.topAnchor.constraint(equalTo: topContainer.topAnchor).isActive = true
//        topImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        topImageView.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor).isActive = true
//        topImageView.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor).isActive = true
//        topImageView.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor).isActive = true
//
//        explorerContainer.translatesAutoresizingMaskIntoConstraints = false
//        explorerContainer.topAnchor.constraint(equalTo: topContainer.bottomAnchor).isActive = true
//        explorerContainer.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor).isActive = true
//        explorerContainer.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor).isActive = true
//
//        explorerCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        explorerCollectionView.topAnchor.constraint(equalTo: explorerContainer.bottomAnchor).isActive = true
//        explorerCollectionView.leadingAnchor.constraint(equalTo: explorerContainer.leadingAnchor).isActive = true
//        explorerCollectionView.trailingAnchor.constraint(equalTo: explorerContainer.trailingAnchor).isActive = true
//        explorerCollectionView.bottomAnchor.constraint(equalTo: explorerContainer.bottomAnchor).isActive = true
//
//        newImagesContainer.translatesAutoresizingMaskIntoConstraints = false
//        newImagesContainer.topAnchor.constraint(equalTo: explorerContainer.bottomAnchor).isActive = true
//        newImagesContainer.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor).isActive = true
//        newImagesContainer.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor).isActive = true
//        newImagesContainer.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor).isActive = true
//
////        newImagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        newImagesCollectionView.topAnchor.constraint(equalTo: newImagesContainer.bottomAnchor).isActive = true
//        newImagesCollectionView.leadingAnchor.constraint(equalTo: newImagesContainer.leadingAnchor).isActive = true
////        newImagesCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
//        newImagesCollectionView.trailingAnchor.constraint(equalTo: newImagesContainer.trailingAnchor).isActive = true
//        newImagesCollectionView.bottomAnchor.constraint(equalTo: newImagesContainer.bottomAnchor).isActive = true
    }

}



extension SearchViewController: UICollectionViewDelegate {
    
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
}

extension SearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case explorerCollectionView:
            return 0
        case newImagesCollectionView:
            return searchViewModel.currentState.photos.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case explorerCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExplorerCollectionViewCell.reuseIdentifier, for: indexPath)
                    as? ExplorerCollectionViewCell else { fatalError() }
            
            return cell
        case newImagesCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewImageCollectionViewCell.reuseIdentifier, for: indexPath)
                    as? NewImageCollectionViewCell else { fatalError() }
            
            let photo = searchViewModel.currentState.photos[indexPath.row]
            
            cell.newImageCollectionViewCellModel = NewImageCollectionViewCellModel(photo: photo)
            
            return cell
        default:
            fatalError()
        }
    }
}

extension SearchViewController: SearchViewOutput {
    func needReload() {
        DispatchQueue.main.async {
            self.newImagesCollectionView.reloadData()
        }
    }
}
