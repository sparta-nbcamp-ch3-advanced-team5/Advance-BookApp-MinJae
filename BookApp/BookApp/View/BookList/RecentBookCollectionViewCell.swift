//
//  RecentBookCollectionViewCell.swift
//  BookApp
//
//  Created by MJ Dev on 5/14/25.
//

import UIKit
import SnapKit

final class RecentBookCollectionViewCell: UICollectionViewCell {
    
    private let bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [bookImageView, bookTitleLabel].forEach {
            contentView.addSubview($0)
        }
        bookImageView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalTo(bookImageView.snp.width).multipliedBy(1.3)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(15)
        }
        bookTitleLabel.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(bookImageView.snp.bottom).offset(10)
        }
    }
    
    func configure(model: Book) {
        self.bookTitleLabel.text = model.title
        guard let url = model.imageURL else { return }
        Task {
            do {
                let image = try await ImageCacheManager.shared.image(urlString: url)
                await MainActor.run {
                    self.bookImageView.image = image
                }
            } catch {
                self.bookImageView.image = UIImage(named: "")
            }
        }
    }
    
}
