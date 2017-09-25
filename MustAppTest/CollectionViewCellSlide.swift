//
//  CollectionViewCellSlide.swift
//  MustAppTest
//
//  Created by Антон Погремушкин on 05.03.17.
//  Copyright © 2017 Антон Погремушкин. All rights reserved.
//

import UIKit

class CollectionViewCellSlide: UICollectionViewCell {
    

    @IBOutlet weak var imageCellView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
