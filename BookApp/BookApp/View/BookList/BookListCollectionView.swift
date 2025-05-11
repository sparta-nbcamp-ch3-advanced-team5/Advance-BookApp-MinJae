//
//  BookListCollectionView.swift
//  BookApp
//
//  Created by MJ Dev on 5/11/25.
//

import UIKit

enum Section: Hashable {
    case search
    case myBook
}

final class BookListCollectionView: UICollectionView {
    
    // DiffableDataSource
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Book>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Book>
    
    private var datasource: DataSource?
    private var section: Section?
    private var item: [Book] = []
    convenience init(section: Section) {
        self.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        self.section = section
        setupUI()
    }
    
    private func setupUI() {
        self.collectionViewLayout = createLayout()
        configureDatasource()
        apply(at: .search, to: self.item)
    }
    // DiffableDatasource 설정
    private func configureDatasource() {
        
        //Cell 등록
        let cellRegistration = UICollectionView.CellRegistration<BookListCollectionViewCell, [Book]> { cell, indexPath, item in
            cell.configure(model: self.item[indexPath.row])
        }
        //Cell 설정
        self.datasource = DataSource(collectionView: self, cellProvider: { collectionView, indexPath, item in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: [item])
            return cell
        })
        
        //header 등록
        let headerRegistration = UICollectionView.SupplementaryRegistration<BookListCollectionHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) {[unowned self] supplementaryView, elementKind, indexPath in
            supplementaryView.configure(with: self.section ?? .search)
        }
        //header 설정
        self.datasource?.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            return self.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
    
    // Snapshot 생성 및 적용
    func apply(at section: Section, to item: [Book]) {
        self.item = item
        var snapshot = SnapShot()
        
        if case .myBook = section {
            snapshot.appendSections([.myBook])
            snapshot.appendItems(self.item, toSection: .myBook)
        }
        
        if case .search = section {
            snapshot.appendSections([.search])
            snapshot.appendItems(self.item, toSection: .search)
        }
        
        datasource?.apply(snapshot, animatingDifferences: true)
    }
    
    // UICollectionViewCompositionalLayout
    private func createLayout() -> UICollectionViewLayout {
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
        section.interGroupSpacing = 10
        section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(40)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]

        return UICollectionViewCompositionalLayout(section: section)
    }
}


