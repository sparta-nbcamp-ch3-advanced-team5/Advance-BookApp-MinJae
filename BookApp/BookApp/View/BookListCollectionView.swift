//
//  BookListCollectionView.swift
//  BookApp
//
//  Created by MJ Dev on 5/11/25.
//

import UIKit

final class BookListCollectionView: UICollectionView {
    
    // DiffableDataSource
    enum Section: Hashable { case main }
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Book>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Book>
    
    var datasource: DataSource?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
        self.collectionViewLayout = createLayout()
        configureDatasource()
        apply()
        self.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // DiffableDatasource 설정
    private func configureDatasource() {
        
        //Cell 등록
        let cellRegistration = UICollectionView.CellRegistration<BookListCollectionViewCell, [Book]> { cell, indexPath, item in
            cell.configure(model: item[indexPath.row])
        }
        //Cell 설정
        self.datasource = DataSource(collectionView: self, cellProvider: { collectionView, indexPath, item in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: [item])
            return cell
        })
        
        //header 등록
        let headerRegistration = UICollectionView.SupplementaryRegistration<BookListCollectionHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
        }
        //header 설정
        self.datasource?.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            return self.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
    
    // snapshot 생성
    private func makeSnapshot() -> SnapShot {
        var snapshot = SnapShot()
        snapshot.appendSections([.main])
        snapshot.appendItems([Book(title: "세이노의 가르침", author: "세이노", price: "14000")], toSection: .main)
        return snapshot
    }
    
    // 적용
    private func apply() {
        datasource?.apply(makeSnapshot(), animatingDifferences: true)
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
        section.orthogonalScrollingBehavior = .continuous
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
