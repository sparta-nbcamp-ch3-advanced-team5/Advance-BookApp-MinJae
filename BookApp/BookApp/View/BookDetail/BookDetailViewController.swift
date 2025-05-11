//
//  BookDetailViewController.swift
//  BookApp
//
//  Created by MJ Dev on 5/11/25.
//

import UIKit
import SnapKit

final class BookDetailViewController: UIViewController {
    
    private var bookDetailView: BookDetailView
    
    init(book: Book) {
        self.bookDetailView = BookDetailView(book: book)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(bookDetailView)
        
        bookDetailView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
