//
//  Safari.swift
//  CodebaseBooks
//
//  Created by pineone on 2022/07/20.
//

import Foundation
import SafariServices

class Safari {
    func safari(data: Book) -> SFSafariViewController {
        let isbn13 = data.isbn13
        let bookUrl = URL(string: "https://itbook.store/books/" + isbn13 )
        
        let bookSafariView: SFSafariViewController = SFSafariViewController(url: bookUrl!)
        return bookSafariView
//        present(bookSafariView, animated: true, completion: nil)
    }
    
}
