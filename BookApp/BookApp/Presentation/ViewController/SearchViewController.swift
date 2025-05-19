//
//  SearchViewController.swift
//  BookApp
//
//  Created by MJ Dev on 5/11/25.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class SearchViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    private let searchResultView: BookListCollectionView
    private let disposeBag = DisposeBag()
    let repoImpl = FetchSearchBookRepositoryImpl(networkManager: NetworkManager())
    let coreRepoImpl = CoreDataRepositoryImpl(coreDataManager: CoreDataManager())
    private lazy var viewModel = SearchViewModel(
        fetchSearchBookUseCase: FetchSearchBookUseCase(repository: repoImpl),
        fetchSearchBookRepeatingUseCase: FetchSearchBookRepeatingUseCase(repository: repoImpl),
        coreDataCreateUseCase: CoreDataCreateUseCase(repository: coreRepoImpl),
        coreDataReadUseCase: CoreDataReadUseCase(repository: coreRepoImpl),
        coreDataDeleteUseCase: CoreDataDeleteUseCase(repository: coreRepoImpl),
        coreDataDeleteAllUseCase: CoreDataDeleteAllUseCase(repository: coreRepoImpl)
    )
    private let popupView = SearchPopupView()
    
    init() {
        self.searchResultView = BookListCollectionView(section: .search)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bind()
        searchBar.delegate = self
    }
    // 바인딩
    private func bind() {
        // 검색결과 컬렉션 뷰의 셀 선택 이벤트 바인딩
        searchResultView.rx.itemSelected
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, indexPath in
                var book: Book?
                if indexPath.section == 0 {
                    if owner.viewModel.recentBooksArray.isEmpty {
                        book = owner.viewModel.fetchedBooksArray[indexPath.row]
                    } else {
                        book = owner.viewModel.recentBooksArray[indexPath.row]
                    }
                } else if indexPath.section == 1 {
                    book = owner.viewModel.fetchedBooksArray[indexPath.row]
                }
                if book == nil { return }
                let detailVC = BookDetailViewController(book: book!)
                detailVC.delegate = self
                owner.present(detailVC, animated: true)
                owner.viewModel.appendRecentBook(&book!)
            })
            .disposed(by: disposeBag)
        
        // 검색 또는 상세페이지 진입 시 컬렉션 뷰 업데이트
        Observable
            .combineLatest(viewModel.fetchedBooks, viewModel.recentBooks)
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe{ (owner, books) in
                owner.searchResultView.apply(at: .recent, to: books.0, recentItem: books.1)
            }.disposed(by: disposeBag)
        
        // 컬렉션뷰의 contentOffset 변경에 따른 이벤트 처리 바인딩
        searchResultView.rx.contentOffset
            .subscribe(with: self, onNext: { owner, offset in
                let collectionViewHeight = owner.searchResultView.contentSize.height
                let deviceHeight = UIScreen.main.bounds.height
                // 추가 업데이트 필요
                if offset.y > abs(collectionViewHeight - deviceHeight) {
                    owner.viewModel.fetchBooksForCurrentQuery()
                }
            }).disposed(by: disposeBag)
    }
    // UI 구성 (설정 변경, View 추가, 레이아웃 설정)
    private func setupUI() {
        [searchBar, searchResultView, popupView].forEach {
            view.addSubview($0)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchResultView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(searchBar.snp.bottom)
        }
        
        popupView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(5)
        }
    }
    // 검색바 활성화
    func activeSearchbar() {
        searchBar.becomeFirstResponder()
    }
}

// MARK: UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text else { return }
        self.searchResultView.setContentOffset(.zero, animated: true)
        viewModel.fetchFirstPageBooks(query: text)
    }
}

// MARK: BookDetailViewControllerDelegate
extension SearchViewController: BookDetailViewControllerDelegate {
    // 상세페이지에서 담기버튼 클릭 시 팝업뷰 보여지도록 설정
    func addButtonTapped(book: Book) {
        popupView.configureLabelText(title: book.title)
        popupView.isHidden = false
        popupView.snp.updateConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        UIView.animate(withDuration: 2.0) { [unowned self] in
            self.view.layoutIfNeeded()
        } completion: { bool in
            self.popupView.isHidden = true
            self.popupView.snp.updateConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }
        }
        
    }
}
