//
//  BookListCollectionViewCell.swift
//  BookApp
//
//  Created by MJ Dev on 5/11/25.
//

import UIKit
import SnapKit

final class BookListCollectionViewCell: UICollectionViewCell {
    
    private let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        label.textAlignment = .right
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // UI 구성 (설정 변경, View 추가, 레이아웃 설정)
    private func setupUI() {
        [bookTitleLabel, authorLabel, priceLabel].forEach {
            contentView.addSubview($0)
        }
        
        bookTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(5)
            $0.width.equalToSuperview().dividedBy(2)
        }
        
        authorLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(bookTitleLabel.snp.trailing).offset(10)
            $0.trailing.equalTo(priceLabel.snp.leading).offset(-10)
        }
        
        priceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.greaterThanOrEqualTo(40)
        }
    }
    // 입력받은 데이터로 UI 그리기
    func configure(model: Book) {
        self.bookTitleLabel.text = model.title
        self.authorLabel.text = model.authors.joined(separator: ", ")
        self.priceLabel.text = "\(model.price)원"
    }
    
}
