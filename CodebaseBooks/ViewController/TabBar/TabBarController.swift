//
//  ViewController.swift
//  CodebaseBooks
//
//  Created by pineone on 2022/07/05.
//

import UIKit

class TabBarController: UITabBarController {

    private lazy var newViewController = totalTabBar(NewViewController(), title: "New", image: "book", tag: 0)

    private lazy var searchViewController = totalTabBar(SearchViewController(), title: "Search", image: "magnifyingglass", tag: 1)

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [newViewController, searchViewController]
    }

    private func totalTabBar(_ vc: UIViewController, title: String, image: String, tag: Int) -> UINavigationController {
        let className = vc
        let viewController = UINavigationController(rootViewController: className)
        let tabBarItem = UITabBarItem(
            title: "\(title)",
            image: UIImage(systemName: "\(image)"),
            tag: tag
        )
        viewController.tabBarItem = tabBarItem

        return viewController
    }
    


}

