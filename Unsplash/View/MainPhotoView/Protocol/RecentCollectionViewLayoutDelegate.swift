//
//  RecentCollectionViewLayoutDelegate.swift
//  Unsplash
//
//  Created by 김수경 on 2024/03/12.
//

import UIKit

protocol RecentCollectionViewLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPaht indexPath: IndexPath) -> CGFloat
}
