//
//  UICollectionView+Extension.swift
//  AH-Assignment-MVVM
//
//  Created by Roman on 07/07/2022.
//

import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ type: T.Type, reuseIdentifier: String? = nil) {
        let typeName = String(describing: T.self)
        register(T.self, forCellWithReuseIdentifier: reuseIdentifier ?? typeName)
    }
    
    func dequeueCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        let typeName = String(describing: T.self)
        guard let cell = dequeueReusableCell(withReuseIdentifier: typeName, for: indexPath) as? T else {
            fatalError("Cannot dequeue cell with class \(typeName)")
        }
        return cell
    }
    
    func registerHeader<T: UICollectionReusableView>(_ type: T.Type, reuseIdentifier: String? = nil) {
        let typeName = String(describing: T.self)
        register(
            T.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: typeName
        )
    }
    
    func dequeueReusableSupplementaryViewHeader<T: UICollectionReusableView>(for indexPath: IndexPath) -> T {
        let typeName = String(describing: T.self)
        guard let header = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: typeName,
            for: indexPath
        ) as? T else {
            fatalError("Cannot dequeue collectionView header with class \(typeName)")
        }
        return header
    }
}
