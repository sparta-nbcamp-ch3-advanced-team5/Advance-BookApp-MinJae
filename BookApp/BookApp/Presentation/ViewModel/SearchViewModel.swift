//
//  SearchViewModel.swift
//  BookApp
//
//  Created by MJ Dev on 5/12/25.
//

import Foundation
import RxSwift

final class SearchViewModel {
    
    private let networkManager: NetworkManager
    private let coreDataManager: CoreDataManager
    private let disposeBag = DisposeBag()
    private(set) var fetchedBooks = BehaviorSubject<[Book]>(value: [])
    private(set) var recentBooks = BehaviorSubject<[Book]>(value: [])
    
    // 데이터 호출 상태 정의
    enum FetchBookDataState {
        case loading
        case ready
        case allLoaded
    }
    // 현재 페이지, 상태, 쿼리값 저장
    private var currentPage = 1
    private var currentState = FetchBookDataState.ready
    private var currentQuery: String?
    
    var fetchedBooksArray: [Book] {
        guard let books = try? fetchedBooks.value() else { return [] }
        return books
    }
    
    var recentBooksArray: [Book] {
        return coreDataManager.read(for: .recentBook)
    }
    
    init(networkManager: NetworkManager = .init(),
         coreDataManager: CoreDataManager = .init()) {
        self.networkManager = networkManager
        self.coreDataManager = coreDataManager
        fetchRecentBooks()
    }
    
    // 현재 데이터 호출옵션 저장 (데이터 호출 후에 호출됨)
    func setCurrentFetchOption() {
        self.currentPage += 1
        self.currentState = .ready
    }
    
    // 현재쿼리와 페이지에 맞는 데이터 불러오기 (무한스크롤 용)
    func fetchBooksForCurrentQuery() {
        
        guard case .ready = currentState,
              let currentQuery = self.currentQuery else {
            return
        }
        
        currentState = .loading
        
        Task {
            await networkManager.fetch(query: currentQuery, page: currentPage)
                .subscribe(onSuccess: {[weak self] (data: BookResponse) in
                    guard let fetchedBooksArray = self?.fetchedBooksArray else { return }
                    if data.meta.isEnd {
                        self?.currentState = .allLoaded
                        return
                    }
                    self?.fetchedBooks.onNext(fetchedBooksArray + data.documents)
                }, onFailure: { error in
                    print(error.localizedDescription)
                }).disposed(by: disposeBag)
        }
    }
    
    // 첫번째 데이터 불러오기
    func fetchFirstPageBooks(query: String) {
        if case .loading = currentState {
            print("데이터 로딩중, fetchBook method is not excuted")
            return
        }
        currentState = .loading
        Task {
            await networkManager.fetch(query: query, page: 1)
                .subscribe(onSuccess: {[weak self] (data: BookResponse) in
                    self?.fetchedBooks.onNext(data.documents)
                    self?.currentQuery = query
                }, onFailure: { error in
                    print(error.localizedDescription)
                }).disposed(by: disposeBag)
        }
    }
    // 최근기록 추가
    func appendRecentBook(_ book: inout Book) {
        // DiffableDataSource에서 셀은 고유해야하므로 isRecent 값 변경하여 저장, 다른곳에선 안쓰인다.
        book.isRecent = true
        var appended = [Book]()
        // 이미 최근 기록에 있는지 판단
        if recentBooksArray.contains(book) {
            // 가장 첫번째에 존재하면 재배치 과정 스킵
            if recentBooksArray[0] == book { return }
            // 이미 최근기록에 있지만 첫번째에 배치되어 있지 않다면 첫번째로 재배치
            var currentRecentBooks = self.recentBooksArray
            for i in 0..<currentRecentBooks.count {
                if book == currentRecentBooks[i] {
                    currentRecentBooks.remove(at: i)
                    break
                }
            }
            appended = [book] + currentRecentBooks
        } else {
            // 최근기록에 없다면 추가
            appended = [book] + recentBooksArray
        }
        appended.count > 10 ? _ = appended.popLast() : nil
        recentBooks.onNext(appended)
        saveRecentBooksInCoreData(recents: appended)
        return
    }
    // 최근 기록 불러오기
    func fetchRecentBooks() {
        recentBooks.onNext(coreDataManager.read(for: .recentBook))
    }
    // 최근 기록 코어데이터 저장 (기존에 저장된 데이터 삭제하고 덮어씌우는 방식)
    private func saveRecentBooksInCoreData(recents: [Book]) {
        deleteAllRecentBooksInCoreData()
        recents.forEach { book in
            coreDataManager.create(for: .recentBook, to: book)
        }
    }
    // 최근기록 데이터 모두 삭제
    private func deleteAllRecentBooksInCoreData() {
        coreDataManager.deleteAll(for: .recentBook)
    }
}
