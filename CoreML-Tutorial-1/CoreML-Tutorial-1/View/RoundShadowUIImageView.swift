//
//  RoundShadowUIImageView.swift
//  CoreML-Tutorial-1
//
//  Created on 19/07/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class RoundShadowUIImageView: UIImageView {

    override func awakeFromNib() {
        self.layer.cornerRadius = 15
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 0.75
    }

}
