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

// 상세페이지 델리게이트 프로토콜
protocol BookDetailViewControllerDelegate: AnyObject {
    func addButtonTapped(book: Book)
}

final class BookDetailViewController: UIViewController {
    
    private var bookDetailView: BookDetailView
    private let disposeBag = DisposeBag()
    private let viewModel: BookDetailViewModel
    
    // 델리게이트, 검색페이지에서 팝업뷰 띄우기 위해 위임자 구성
    weak var delegate: BookDetailViewControllerDelegate?
    
    init(book: Book) {
        let coredataImpl = CoreDataRepositoryImpl(coreDataManager: CoreDataManager())
        self.viewModel = BookDetailViewModel(item: book,
                                             coreDataReadUseCase: CoreDataReadUseCase(repository: coredataImpl),
                                             coreDataCreateUseCase: CoreDataCreateUseCase(repository: coredataImpl)
        )
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
    // UI 구성 (설정 변경, View 추가, 레이아웃 설정)
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
            .subscribe{ owner, event in
                owner.viewModel.saveBook()
                owner.dismiss(animated: true)
                owner.delegate?.addButtonTapped(book: owner.viewModel.item) // 검색페이지에 책 데이터 전달
            }
            .disposed(by: disposeBag)
    }
    
}
