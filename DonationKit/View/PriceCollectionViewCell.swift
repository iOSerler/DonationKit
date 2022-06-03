//
//  PriceCollectionViewCell.swift
//  
//
//  Created by Daniya on 08/01/2022.
//

import UIKit

class PriceCollectionViewCell: UICollectionViewCell {
    
    lazy var textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
    
    // must call super
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textLabel.clipsToBounds = true
        textLabel.layer.borderWidth = 1
        textLabel.numberOfLines = 0
        textLabel.layer.cornerRadius = 10
        textLabel.font = UIFont.boldSystemFont(ofSize: 19)
        textLabel.textAlignment = NSTextAlignment.center
        addSubview(textLabel)
    }
    
    // we have to implement this initializer, but will only ever use this class programmatically
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(colour: UIColor) {
        self.backgroundColor = colour
    }
}
