//
//  SearchViewModel.swift
//  BookApp
//
//  Created by MJ Dev on 5/12/25.
//

import Foundation
import RxSwift

final class SearchViewModel {
    
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
    private var currentState = FetchBookDataState.ready
    
    var fetchedBooksArray: [Book] {
        guard let books = try? fetchedBooks.value() else { return [] }
        return books
    }
    
    var recentBooksArray: [Book] {
        return coreDataReadUseCase.execute(for: .recentBook)
    }
    
    private let fetchSearchBookUseCase: FetchSearchBookUseCase
    private let fetchSearchBookRepeatingUseCase: FetchSearchBookRepeatingUseCase
    private let coreDataCreateUseCase: CoreDataCreateUseCase
    private let coreDataReadUseCase: CoreDataReadUseCase
    private let coreDataDeleteUseCase: CoreDataDeleteUseCase
    private let coreDataDeleteAllUseCase: CoreDataDeleteAllUseCase
    
    init(
        fetchSearchBookUseCase: FetchSearchBookUseCase,
        fetchSearchBookRepeatingUseCase: FetchSearchBookRepeatingUseCase,
        coreDataCreateUseCase: CoreDataCreateUseCase,
        coreDataReadUseCase: CoreDataReadUseCase,
        coreDataDeleteUseCase: CoreDataDeleteUseCase,
        coreDataDeleteAllUseCase: CoreDataDeleteAllUseCase
    ) {
        self.fetchSearchBookUseCase = fetchSearchBookUseCase
        self.fetchSearchBookRepeatingUseCase = fetchSearchBookRepeatingUseCase
        self.coreDataCreateUseCase = coreDataCreateUseCase
        self.coreDataReadUseCase = coreDataReadUseCase
        self.coreDataDeleteUseCase = coreDataDeleteUseCase
        self.coreDataDeleteAllUseCase = coreDataDeleteAllUseCase
        
        fetchRecentBooks()
    }
    
    // 현재쿼리와 페이지에 맞는 데이터 불러오기 (무한스크롤 용)
    func fetchBooksForCurrentQuery() {
        
        guard case .ready = currentState else {
            return
        }
        
        currentState = .loading
        
        Task {
            await fetchSearchBookRepeatingUseCase.execute()
                .subscribe(with: self, onSuccess: { owner, response in
                    let fetchedBooksArray = owner.fetchedBooksArray
                    owner.fetchedBooks.onNext(fetchedBooksArray + response.documents)
                    if response.meta.isEnd {
                        owner.currentState = .allLoaded
                    } else {
                        owner.currentState = .ready
                    }
                }) { owner, error in
                    print(#function)
                    print(error.localizedDescription)
                }.disposed(by: disposeBag)
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
            await fetchSearchBookUseCase.execute(query: query, page: 1)
                .subscribe(with: self, onSuccess: { owner, response in
                    owner.fetchedBooks.onNext(response.documents)
                    owner.currentState = .ready
                }) { owner, error in
                    print(#function)
                    print(error.localizedDescription)
                }.disposed(by: disposeBag)
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
        let recent = coreDataReadUseCase.execute(for: .recentBook)
        recentBooks.onNext(recent)
    }
    // 최근 기록 코어데이터 저장 (기존에 저장된 데이터 삭제하고 덮어씌우는 방식)
    private func saveRecentBooksInCoreData(recents: [Book]) {
        deleteAllRecentBooksInCoreData()
        recents.forEach { book in
            coreDataCreateUseCase.execute(for: .recentBook, to: book)
        }
    }
    // 최근기록 데이터 모두 삭제
    private func deleteAllRecentBooksInCoreData() {
        coreDataDeleteAllUseCase.execute(for: .recentBook)
    }
}
