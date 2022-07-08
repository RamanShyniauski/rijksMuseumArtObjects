//
//  OverviewCollectionHeaderView.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 07/07/2022.
//

import SnapKit
import UIKit

class OverviewCollectionHeaderView: UICollectionReusableView {
        
    private lazy var labelView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textColor = .black
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray.withAlphaComponent(0.5)
        addSubview(labelView)
        labelView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(10)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with title: String) {
        labelView.text = title
    }
}
