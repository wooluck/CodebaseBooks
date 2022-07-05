//
//  ViewController.swift
//  CodebaseBooks
//
//  Created by pineone on 2022/07/05.
//

import UIKit

class TabBarController: UITabBarController {

    private lazy var newViewController: UIViewController = {
        let viewController = UINavigationController(rootViewController: NewViewController())
        let tabBarItem = UITabBarItem(
            title: "New",
            image: UIImage(systemName: "book"),
            tag: 0
        )
        viewController.tabBarItem = tabBarItem

        return viewController
    }()

    private lazy var searchViewController: UIViewController = {
        let viewController = UINavigationController(rootViewController: SearchViewController())
        let tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass"),
            tag: 1
        )
        viewController.tabBarItem = tabBarItem

        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [newViewController, searchViewController]
    }


}

