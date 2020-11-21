//
//  CustomNavigationDelegate.swift
//  Unsplash
//
//  Created by Minsoo Kim on 2020/11/21.
//

import UIKit

protocol ViewControllerDismissDelegate: class {
    func dismissCalledFromChild(lastIndexPath: IndexPath)
}

