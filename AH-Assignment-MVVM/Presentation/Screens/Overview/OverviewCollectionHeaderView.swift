//
//  OverviewCollectionHeaderView.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 07/07/2022.
//

import SnapKit
import UIKit

class OverviewCollectionHeaderView: UICollectionReusableView {
        
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 24)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.8
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .lightGray
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(10)
        }
    }
    
    func setup(with title: String) {
        titleLabel.text = title
    }
}
