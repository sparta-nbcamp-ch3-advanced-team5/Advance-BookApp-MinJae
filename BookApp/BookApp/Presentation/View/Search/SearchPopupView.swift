//
//  SearchPopupView.swift
//  BookApp
//
//  Created by MJ Dev on 5/12/25.
//

import UIKit
import SnapKit

final class SearchPopupView: UIView {
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .gray
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        self.isHidden = true
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // UI 구성 (설정 변경, View 추가, 레이아웃 설정)
    private func setupUI() {
        [label].forEach {
            self.addSubview($0)
        }
        
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }
    
    func configureLabelText(title: String) {
        self.label.text = "✅ \(title)책 담기 완료!"
    }
}
