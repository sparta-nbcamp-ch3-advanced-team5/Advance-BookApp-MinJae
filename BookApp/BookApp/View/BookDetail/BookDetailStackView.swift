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
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    convenience init(book: Book) {
        self.init(frame: .zero)
        setupUI()
        configure(with: book)
    }
    
    private func setupUI() {
        self.axis = .vertical
        self.distribution = .fill
        self.alignment = .center
        self.isLayoutMarginsRelativeArrangement = true
        self.spacing = 20
        self.layoutMargins = .init(top: 20, left: 20, bottom: 20, right: 20)
        [titleLabel, authorLabel, bookImageView, priceLabel, descriptionLabel].forEach {
            self.addArrangedSubview($0)
        }
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        authorLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        priceLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        bookImageView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.6)
            $0.height.equalToSuperview().multipliedBy(0.5)
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
