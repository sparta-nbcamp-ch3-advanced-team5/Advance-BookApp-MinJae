//
//  SearchViewController.swift
//  BookApp
//
//  Created by MJ Dev on 5/11/25.
//

import UIKit
import SnapKit

final class SearchViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    private let searchResultView = BookListCollectionView(section: .search)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    private func setupUI() {
        [searchBar, searchResultView].forEach {
            view.addSubview($0)
        }
        searchBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        searchResultView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(searchBar.snp.bottom)
        }
    }
}
