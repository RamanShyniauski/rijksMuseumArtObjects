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
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.8
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
    }
    
    private func setupView() {
        backgroundColor = .lightGray
        layer.cornerRadius = 5
        addSubview(stackView)
        imageView.kf.indicatorType = .activity
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
    }
    
    func setup(with model: OverviewCollectionViewCellModel) {
        titleLabel.text = model.title
        imageView.layoutIfNeeded()
        imageView.kf.setImage(
            with: model.imageURL,
            options: [
                .processor(DownsamplingImageProcessor(size: imageView.bounds.size)),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .onFailureImage(UIImage(systemName: "eye.trianglebadge.exclamationmark"))
            ]
        )
    }
}
