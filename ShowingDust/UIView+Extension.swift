//
//  UIView+Extension.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/07.
//

import UIKit

extension UIView {

    func setRoundCorner() {
        layer.cornerRadius = frame.height/2
        layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.borderWidth = 2.5
    }
}
