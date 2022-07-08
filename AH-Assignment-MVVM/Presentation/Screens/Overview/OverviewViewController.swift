//
//  OverviewViewController.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 06/07/2022.
//

import Combine
import SnapKit
import UIKit

class OverviewViewController: UIViewController {
    
    private let numberOfCellsInRow: CGFloat = 3
    private let cellInteritemSpacing: CGFloat = 10
    private let sectionLeftRightSpacing: CGFloat = 10
    private let paginationViewHeight: CGFloat = 40
    private var paginationTopConstraint: Constraint?
    
    private var viewModel: OverviewViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var paginationView: PaginationView = {
        let pagination = PaginationView()
        pagination.delegate = self
        return pagination
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(
            top: 20,
            left: sectionLeftRightSpacing,
            bottom: 10,
            right: sectionLeftRightSpacing
        )
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = cellInteritemSpacing
        layout.minimumLineSpacing = 20
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.contentInset.bottom = paginationViewHeight
        collection.register(OverviewCollectionViewCell.self)
        collection.registerReusableView(
            OverviewCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        return collection
    }()
    
    private lazy var loaderView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.hidesWhenStopped = true
        return loader
    }()
    
    private lazy var messageView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    init(viewModel: OverviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupBindings()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        viewModel.didLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        paginationTopConstraint?.update(offset: collectionView.contentSize.height)
    }
}

private extension OverviewViewController {
    
    func setupView() {
        view.backgroundColor = .white
        title = "Overview"
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.addSubview(paginationView)
        paginationView.isHidden = true
        view.addSubview(collectionView)
        view.addSubview(loaderView)
        view.addSubview(messageView)
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loaderView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        messageView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        paginationView.snp.makeConstraints { make in
            make.height.equalTo(paginationViewHeight)
            make.centerX.equalToSuperview()
            let offsetHeight = collectionView.contentSize.height
            paginationTopConstraint = make.top.equalToSuperview().offset(offsetHeight).constraint
        }
    }
    
    func setupBindings() {
        viewModel
            .statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .loading:
                    self?.handleLoadingState()
                case .loaded:
                    self?.handleLoadedState()
                case .empty:
                    self?.handleEmptyState()
                case .error(let error):
                    self?.handleErrorState(error)
                }
            }
            .store(in: &cancellables)
    }
    
    func handleLoadingState() {
        loaderView.startAnimating()
        loaderView.isHidden = false
        messageView.isHidden = true
        collectionView.isUserInteractionEnabled = false
    }
    
    func handleLoadedState() {
        collectionView.reloadData()
        collectionView.isUserInteractionEnabled = true
        collectionView.isHidden = false
        paginationView.isHidden = false
        loaderView.isHidden = true
        messageView.isHidden = true
        paginationView.updateBackButtonState(isEnabled: viewModel.isBackPaginationAvailable)
        paginationView.updateForwardButtonState(isEnabled: viewModel.isForwardPaginationAvailable)
    }
    
    func handleEmptyState() {
        messageView.text = "No Art objects available!"
        messageView.isHidden = false
        collectionView.isHidden = true
        loaderView.isHidden = true
        paginationView.isHidden = true
    }
    
    func handleErrorState(_ error: String) {
        messageView.text = error
        messageView.isHidden = false
        collectionView.isHidden = true
        loaderView.isHidden = true
        paginationView.isHidden = true
    }
}

extension OverviewViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.frame.size.width, height: 50)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView: OverviewCollectionHeaderView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                for: indexPath
            )
            let sectionTitle = viewModel.titleForSection(indexPath.section)
            headerView.setup(with: sectionTitle)
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfRows(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OverviewCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        let cellModel = viewModel.cellModel(at: indexPath)
        cell.setup(with: cellModel)
        return cell
    }
}

extension OverviewViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath)
    }
}

extension OverviewViewController : UICollectionViewDelegateFlowLayout{

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let horizontalSpacing = sectionLeftRightSpacing * 2
        let rowsInteritemSpacing = cellInteritemSpacing * (numberOfCellsInRow - 1)
        let widthHeight = (collectionViewWidth - horizontalSpacing - rowsInteritemSpacing) / numberOfCellsInRow
        return CGSize(width: widthHeight, height: widthHeight)
    }
}

extension OverviewViewController: PaginationViewDelegate {
    
    func goBack() {
        collectionView.scrollToFirstItem()
        viewModel.goBack()
    }

    func goForward() {
        collectionView.scrollToFirstItem()
        viewModel.goForward()
    }
}
