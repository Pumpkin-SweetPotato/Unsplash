//
//  DetailViewModel.swift
//  Unsplash
//
//  Created by Minsoo Kim on 2020/11/18.
//

import UIKit

protocol DetailViewInput: AnyObject {
    func shareButtonTapped()
    func infoButtonTapped()
    func likeButtonTapped()
    func plusButtonTapped()
    func downloadButtonTapped()
}

protocol DetailViewOutput: AnyObject {
}

class DetailViewModel: DetailViewInput {
    
    weak var detailViewOutput: DetailViewOutput?
    
    let initialState: State
    var currentState: State
    
    struct State {
        var photos: [Photo]
    }
    
    let apiClient: APIClient = APIClient()
    
    init(detailViewOutput: DetailViewOutput) {
        initialState = State(photos: [])
        currentState = initialState
        self.detailViewOutput = detailViewOutput
    }
}
