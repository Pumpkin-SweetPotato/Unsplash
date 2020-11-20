//
//  CustomNavigationDelegate.swift
//  Unsplash
//
//  Created by ZES2017MBP on 2020/11/21.
//

import UIKit

protocol ViewControllerDismissDelegate: UIViewController {
    func popupViewControllerCalled(currentIndexPath: IndexPath)
}

