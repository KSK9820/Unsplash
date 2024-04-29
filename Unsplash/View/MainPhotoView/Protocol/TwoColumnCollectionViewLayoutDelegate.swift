//
//  TwoColumnCollectionViewLayoutDelegate.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/12.
//

import UIKit

protocol TwoColumnCollectionViewLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}
