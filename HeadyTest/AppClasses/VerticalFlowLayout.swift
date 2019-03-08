//  VerticalFlowLayout.swift
//  HeadyTest
//
//  Created by Deeksha on 3/7/19.
//  Copyright © 2019 Deeksha. All rights reserved.
//

import UIKit

/// Vertical Flow Layout
class VerticalFlowLayout: UICollectionViewFlowLayout {
    //MARK: Life Cycle of UICollectionViewCell
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    /// Item size for collection view
    override var itemSize: CGSize {
        set {
        }
        get {
            let numberOfColumns: CGFloat = 2
            let itemWidth = (self.collectionView!.frame.width - (numberOfColumns - 1)) / numberOfColumns
            return CGSize(width: itemWidth, height: itemWidth)
        }
    }
    
    /// Set up layout for collection view
    func setupLayout() {
        minimumInteritemSpacing = 1
        minimumLineSpacing = 1
        scrollDirection = .vertical
    }
}
