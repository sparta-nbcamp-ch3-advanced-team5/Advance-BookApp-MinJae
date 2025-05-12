//
//  BookDetailStackView.swift
//  BookApp
//
//  Created by MJ Dev on 5/11/25.
//

import UIKit

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
        imageView.contentMode = .scaleAspectFit
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
        self.layoutMargins = .init(top: 10, left: 20, bottom: 10, right: 20)
        [titleLabel, authorLabel, bookImageView, priceLabel, descriptionLabel].forEach {
            self.addArrangedSubview($0)
        }
    }
    
    private func configure(with book: Book) {
        self.titleLabel.text = book.title
        self.authorLabel.text = book.authors.joined(separator: ", ")
        self.bookImageView.image = UIImage(named: book.imageURL ?? "")
        self.priceLabel.text = "\(book.price)원"
        self.descriptionLabel.text = book.description
    }
    
}
