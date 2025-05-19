//
//  MyBookViewController.swift
//  BookApp
//
//  Created by MJ Dev on 5/11/25.
//

import UIKit
import SnapKit
import RxSwift

final class MyBookViewController: UIViewController {

    private(set) var myBookCollectionView = BookListCollectionView(section: .myBook)
    private let viewModel = MyBookViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bind()
        myBookCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchMyBooks()
    }
    // UI 구성 (설정 변경, View 추가, 레이아웃 설정)
    private func setupUI() {
        view.addSubview(myBookCollectionView)
        
        myBookCollectionView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    // 바인딩
    private func bind() {
        // 담긴 책 리스트 바인딩
        viewModel.myBooks
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe{ owner, books in
                owner.myBookCollectionView.apply(at: .myBook, to: books)
            }
            .disposed(by: disposeBag)
        
        // 전체 삭제 버튼 바인딩
        myBookCollectionView.deleteAllButtonEvents
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe{ owner, event in
                owner.viewModel.deleteAllBooks()
            }.disposed(by: disposeBag)
    }
}

// MARK: - CollectionViewDelegate
extension MyBookViewController: UICollectionViewDelegate {
    // 스와이프 대신 셀 꾹 선택 시 UIMenu가 나오고 삭제 버튼 클릭 가능
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash")) { _ in
                guard let books = try? self?.viewModel.myBooks.value() else { return }
                let book = books[indexPaths[0].row]
                self?.viewModel.deleteBook(book: book)
            }
            return UIMenu(title: "", children: [deleteAction])
        }
    }

}
