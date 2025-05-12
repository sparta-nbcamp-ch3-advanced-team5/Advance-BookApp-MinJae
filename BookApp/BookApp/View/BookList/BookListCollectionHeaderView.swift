//
//  BookListCollectionHeaderView.swift
//  BookApp
//
//  Created by MJ Dev on 5/11/25.
//

import UIKit
import SnapKit

final class BookListCollectionHeaderView: UICollectionReusableView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    let removeAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체 삭제", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [titleLabel, removeAllButton, addButton].forEach {
            addSubview($0)
        }
    }
    
    func configure(with section: Section) {
        titleLabel.snp.removeConstraints()
        removeAllButton.snp.removeConstraints()
        addButton.snp.removeConstraints()
        
        if case .myBook = section {
            titleLabel.text = "담은 책"
            removeAllButton.isHidden = false
            addButton.isHidden = false
            titleLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            
            removeAllButton.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview()
            }
            
            addButton.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview()
            }
            
        }
        
        if case .search = section {
            titleLabel.text = "검색 결과"
            removeAllButton.isHidden = true
            addButton.isHidden = true
            titleLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview()
            }
        }
    }
    
}
