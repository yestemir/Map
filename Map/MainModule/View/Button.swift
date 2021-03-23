//
//  Button.swift
//  Map
//
//  Created by Dina Yestemir on 22.03.2021.
//

import Foundation
import UIKit
import MapKit

class MapButton: UIButton {
    
    init(buttonImage: String) {
        super.init(frame: .zero)
        layer.cornerRadius = 25
        layer.backgroundColor = UIColor.white.cgColor
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        setImage(UIImage(systemName: buttonImage), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


