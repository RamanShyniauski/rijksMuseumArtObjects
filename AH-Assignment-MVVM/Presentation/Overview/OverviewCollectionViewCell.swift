//
//  OverviewCollectionViewCell.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 07/07/2022.
//

import Kingfisher
import SnapKit
import UIKit

class OverviewCollectionViewCell: UICollectionViewCell {
    
    private lazy var labelView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(labelView)
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(stackView)
        imageView.kf.indicatorType = .activity
        stackView.snp.makeConstraints { make in
            make.bottom.top.leading.trailing.equalTo(0)
        }
        labelView.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.bottom.leading.trailing.equalTo(0)
        }
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(0)
            make.bottom.equalTo(labelView.snp.top)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
    }
    
    func setup(_ model: OverviewCollectionViewCellModel) {
        labelView.text = model.title
        imageView.layoutIfNeeded()
        imageView.kf.setImage(
            with: model.imageURL,
            placeholder: UIImage(systemName: "rectangle.dashed"),
            options: [
                .processor(DownsamplingImageProcessor(size: imageView.bounds.size)),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
        )
    }
}
