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
        label.textAlignment = .center
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
        stack.alignment = .center
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(labelView)
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray.withAlphaComponent(0.3)
        layer.cornerRadius = 5
        addSubview(stackView)
        imageView.kf.indicatorType = .activity
        stackView.snp.makeConstraints { make in
            make.bottom.top.leading.trailing.equalTo(0)
        }
        labelView.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.leading.bottom.equalTo(5)
            make.trailing.equalTo(-5)
        }
        imageView.snp.makeConstraints { make in
            make.left.top.equalTo(5)
            make.right.equalTo(-5)
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
    
    func setup(with model: OverviewCollectionViewCellModel) {
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
