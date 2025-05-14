//
//  BookListCollectionView.swift
//  BookApp
//
//  Created by MJ Dev on 5/11/25.
//

import UIKit
import RxSwift
import RxCocoa

// 재사용 되는 컬렉션 타입 열거형
// .search: 검색페이지의 컬렉션 뷰, .myBook: 마이북페이지의 컬렉션 뷰
enum CollectionType {
    case search
    case myBook
}

// 컬렉션 뷰의 섹션 영역 열거형
enum Section: Hashable {
    case search
    case myBook
    case recent
}

final class BookListCollectionView: UICollectionView {
    
    // DiffableDataSource
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Book>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Book>
    
    private var datasource: DataSource?
    private var section: CollectionType?
    
    // 헤더뷰의 전체삭제버튼 이벤트 Subject
    private(set) var deleteAllButtonEvents = PublishSubject<Void>()
    // 헤더뷰의 추가버튼 이벤트 Subject
    private(set) var addButtonEvents = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    convenience init(section: CollectionType) {
        self.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        self.section = section
        setupUI()
    }
    
    private func setupUI() {
        self.collectionViewLayout = createLayout()
        configureDatasource()
    }
    // Snapshot 생성 및 적용
    func apply(at section: Section, to item: [Book], recentItem: [Book] = []) {
        var snapshot = SnapShot()
        
        if case .myBook = section {
            snapshot.appendSections([.myBook])
            snapshot.appendItems(item, toSection: .myBook)
        } else {
            snapshot.appendSections([.recent, .search])
            if case .search = section {
                snapshot.appendItems(item, toSection: .search)
            }
            if case .recent = section {
                snapshot.appendItems(item, toSection: .search)
                snapshot.appendItems(recentItem, toSection: .recent)
            }
        }
        datasource?.apply(snapshot, animatingDifferences: true)
    }
    
}

// MARK: DiffableDataSource Configure
private extension BookListCollectionView {
    // DiffableDatasource 설정
    private func configureDatasource() {
        // Cell 생성
        // 리스트 셀
        let listCellRegistration = UICollectionView.CellRegistration<BookListCollectionViewCell, Book> { cell, indexPath, item in
            cell.configure(model: item)
        }
        // 최근기록 셀
        let recentCellRegistration = UICollectionView.CellRegistration<RecentBookCollectionViewCell, Book> { cell, indexPath, item in
            cell.configure(model: item)
        }
        
        //Cell 설정
        self.datasource = DataSource(collectionView: self, cellProvider: { collectionView, indexPath, item in
            
            var cell = UICollectionViewCell()
            // 컬렉션 뷰가 위치한 페이지(검색, 마이북)에 따라 셀 다르게 구성
            switch self.section {
            case .myBook:
                cell = collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: item)
            case .search:
                if indexPath.section == 0 {
                    cell = collectionView.dequeueConfiguredReusableCell(using: recentCellRegistration, for: indexPath, item: item)
                } else {
                    cell = collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: item)
                }
            default:
                break
            }
            return cell
        })
        
        //header 등록
        let headerRegistration = UICollectionView.SupplementaryRegistration<BookListCollectionHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) {[unowned self] supplementaryView, elementKind, indexPath in
            
            // 컬렉션 뷰가 위치한 페이지(검색, 마이북)에 따라 헤더 뷰 다르게 구성
            if self.section == .myBook {
                supplementaryView.configure(with: .myBook)
            } else if self.section == .search {
                if indexPath.count == 1 {
                    supplementaryView.configure(with: .search)
                } else {
                    if indexPath.section == 0 {
                        supplementaryView.configure(with: .recent)
                    } else if indexPath.section == 1 {
                        supplementaryView.configure(with: .search)
                    }
                }
            }
            
            // 헤더뷰 버튼 바인딩
            supplementaryView.removeAllButton.rx.tap
                .bind(to: deleteAllButtonEvents)
                .disposed(by: disposeBag)
            supplementaryView.addButton.rx.tap
                .bind(to: addButtonEvents)
                .disposed(by: disposeBag)
        }
        //header 설정
        self.datasource?.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            return self.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
}

// MARK: CompositionalLayout Configure
private extension BookListCollectionView {
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment -> NSCollectionLayoutSection in
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(40)
            )
            
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
            switch sectionIndex {
            case 0:
                if case .myBook = self.section {
                    let section = self.createListCellLayout()
                    section.boundarySupplementaryItems = [header]
                    return section
                } else {
                    let section = self.createRecentSectionLayout()
                    section.boundarySupplementaryItems = [header]
                    return section
                }
            default:
                let section = self.createListCellLayout()
                section.boundarySupplementaryItems = [header]
                return section
            }
        }
    }
    // 리스트 셀 레이아웃
    private func createListCellLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.1)
        )
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 15, trailing: 20)
        section.interGroupSpacing = 10
        
        return section
    }
    // 최근기록 셀 셀 레이아웃
    private func createRecentSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 20, trailing: 20)
        
        return section
    }
}
