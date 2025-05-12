//
//  BookDetailViewController.swift
//  BookApp
//
//  Created by MJ Dev on 5/11/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class BookDetailViewController: UIViewController {
    
    private var bookDetailView: BookDetailView
    private let disposeBag = DisposeBag()
    private let viewModel: BookDetailViewModel
    
    init(book: Book) {
        self.viewModel = BookDetailViewModel(item: book)
        self.bookDetailView = BookDetailView(book: viewModel.item)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        bind()
    }
    
    private func setupUI() {
        view.addSubview(bookDetailView)
        
        bookDetailView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bind() {
        // FooterView의 X버튼 탭 이벤트 바인딩
        bookDetailView.bookDetailFooterView.cancelButton.rx.tap
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { event in
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        // FooterView의 담기버튼 탭 이벤트 바인딩
        bookDetailView.bookDetailFooterView.addButton.rx.tap
            .withUnretained(self)
            .subscribe{ event in
                self.viewModel.saveBook()
            }
            .disposed(by: disposeBag)
    }
    
}
