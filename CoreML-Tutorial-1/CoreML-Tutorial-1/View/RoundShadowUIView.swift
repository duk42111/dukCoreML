//
//  RoundShadowUIView.swift
//  CoreML-Tutorial-1
//
//  Created by udaykanthd on 19/07/18.
//  Copyright © 2018 udaykanthd. All rights reserved.
//

import UIKit

class RoundShadowUIView: UIView {

    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 0.75
        }

}
