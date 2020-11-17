//
//  SearchViewModel.swift
//  Unsplash
//
//  Created by eazel7 on 2020/11/17.
//

import UIKit

protocol SearchViewInput: AnyObject {
    func viewDidLoad()
}

protocol SearchViewOutput: AnyObject {
    func needReload()
}

class SearchViewModel: SearchViewInput {
    
    weak var searchViewOutput: SearchViewOutput?
    
    let initialState: State
    var currentState: State
    
    struct State {
        var photos: [Photo]
    }
    
    let apiClient: APIClient = APIClient()
    
    init(searchViewOutput: SearchViewOutput) {
        initialState = State(photos: [])
        currentState = initialState
        self.searchViewOutput = searchViewOutput
    }
    
    func viewDidLoad() {
        apiClient.reqeust([Photo].self, apiRouter: .getPhoto(page: 1, perPage: 10, orderBy: .latest)) { [weak self] result in
            switch result {
            case .success(let photo):
                print("success")
                self?.currentState.photos = photo
                self?.searchViewOutput?.needReload()
            case .failure(let error):
                print("error \(error)")
            }
        }
    }
}
