//
//  SearchViewModel.swift
//  Unsplash
//
//  Created by Minsoo Kim on 2020/11/17.
//

import UIKit

protocol SearchViewInput: AnyObject {
    func viewDidLoad()
}

protocol SearchViewOutput: AnyObject {
    func needReloadExplorerCollectionView()
    func needReloadNewImageCollectionView()
    func didImageItemAdded(indexPaths: [IndexPath])
}

class SearchViewModel: SearchViewInput {
    
    weak var searchViewOutput: SearchViewOutput?
    
    let initialState: State
    var currentState: State
    
    struct State {
        var explorerPhotos: [Photo]
        var newImagePhotos: [Photo]
    }
    
    let apiClient: APIClient = APIClient()
    
    init(searchViewOutput: SearchViewOutput) {
        initialState = State(newImagePhotos: [])
        currentState = initialState
        self.searchViewOutput = searchViewOutput
    }
    
    func viewDidLoad() {
        apiClient.reqeust([Photo].self, apiRouter: .getPhoto(page: 1, perPage: 10, orderBy: .latest)) { [weak self] result in
            switch result {
            case .success(let photo):
                print("success")
                self?.currentState.newImagePhotos = photo
                self?.searchViewOutput?.needReloadNewImageCollectionView()
            case .failure(let error):
                print("error \(error)")
            }
        }
    }

    
}
