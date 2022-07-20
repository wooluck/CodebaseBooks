//
//  Safari.swift
//  CodebaseBooks
//
//  Created by pineone on 2022/07/20.
//

import Foundation
import SafariServices

class Safari {
    func safari(data: String) -> SFSafariViewController {
        let bookUrl = URL(string: "https://itbook.store/books/" + data )
        
        let bookSafariView: SFSafariViewController = SFSafariViewController(url: bookUrl!)
        return bookSafariView
//        present(bookSafariView, animated: true, completion: nil)
    }
    
}

class SafariView: SFSafariViewController {
    
    let host = "https://itbook.store/books/"
    
    init(path: String) {
        super.init(url: URL(string: host+path)!)
    }
    
    override init(url URL: URL, configuration: SFSafariViewController.Configuration) {
        super.init(url: URL, configuration: configuration)
    }
}
