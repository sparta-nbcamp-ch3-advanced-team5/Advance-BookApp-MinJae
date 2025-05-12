//
//  BookDetailFooterView.swift
//  BookApp
//
//  Created by MJ Dev on 5/11/25.
//

import UIKit
import SnapKit

final class BookDetailFooterView: UIView {
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.backgroundColor = .lightGray
        button.tintColor = .white
        return button
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("담기", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.backgroundColor = .systemGreen
        button.tintColor = .white
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [cancelButton, addButton].forEach {
            self.addSubview($0)
        }
        
        cancelButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(15)
            $0.width.height.equalTo(60)
        }
        addButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(15)
            $0.leading.equalTo(cancelButton.snp.trailing).offset(15)
            $0.width.greaterThanOrEqualTo(cancelButton).multipliedBy(4)
            $0.height.equalTo(60)
        }
    }
    
}
