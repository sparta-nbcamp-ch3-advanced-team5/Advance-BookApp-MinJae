//
//  BookDetailView.swift
//  BookApp
//
//  Created by MJ Dev on 5/11/25.
//

import UIKit
import SnapKit

final class BookDetailView: UIView {
    
    private let scrollView = UIScrollView()
    private let bookDetailStackView: BookDetailStackView
    let bookDetailFooterView = BookDetailFooterView()
    
    init(book: Book) {
        self.bookDetailStackView = BookDetailStackView(book: book)
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // UI 구성 (설정 변경, View 추가, 레이아웃 설정)
    private func setupUI() {
        self.addSubview(scrollView)
        self.addSubview(bookDetailFooterView)
        scrollView.addSubview(bookDetailStackView)
        bookDetailFooterView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(100)
        }
        scrollView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.leading.trailing.top.equalToSuperview()
            $0.bottom.equalTo(bookDetailFooterView.snp.top)
        }
        bookDetailStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
}
