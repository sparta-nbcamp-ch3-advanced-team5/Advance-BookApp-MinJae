//
//  BookDetailStackView.swift
//  BookApp
//
//  Created by MJ Dev on 5/11/25.
//

import UIKit
import SnapKit

final class BookDetailStackView: UIStackView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    convenience init(book: Book) {
        self.init(frame: .zero)
        setupUI()
        configure(with: book)
    }
    // UI 구성 (설정 변경, View 추가, 레이아웃 설정)
    private func setupUI() {
        self.axis = .vertical
        self.distribution = .fill
        self.alignment = .center
        self.isLayoutMarginsRelativeArrangement = true
        self.spacing = 20
        self.layoutMargins = .init(top: 10, left: 0, bottom: 20, right: 0)
        [titleLabel, authorLabel, bookImageView, priceLabel, descriptionLabel].forEach {
            self.addArrangedSubview($0)
        }
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(25)
            $0.width.lessThanOrEqualToSuperview()
        }
        authorLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.width.lessThanOrEqualToSuperview()
        }
        priceLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.width.lessThanOrEqualToSuperview()
        }
        bookImageView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalTo(bookImageView.snp.width).multipliedBy(1.4)
        }
        descriptionLabel.snp.makeConstraints {
            $0.width.lessThanOrEqualToSuperview().multipliedBy(0.8)
        }
    }
    
    private func configure(with book: Book) {
        self.titleLabel.text = book.title
        self.authorLabel.text = book.authors.joined(separator: ", ")
        self.priceLabel.text = "\(book.price)원"
        self.descriptionLabel.text = book.description
        
        Task {
            guard let urlString = book.imageURL,
                  let image = try? await ImageCacheManager.shared.image(urlString: urlString)
            else {
                await MainActor.run {
                    self.bookImageView.image = UIImage(named: "")
                }
                return
            }
            await MainActor.run {
                self.bookImageView.image = image
            }
        }
        
    }
    
}
