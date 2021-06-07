//
//  GradientView.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/07.
//

import UIKit
/// 그라데이션 배경색을 가지는 UIView
final class GradientView: UIView {

    let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setGradient()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setGradient()
    }
    
    private func setGradient() {
        gradientLayer.colors = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = frame
        layer.insertSublayer(gradientLayer, at: 0)
    }

    func changeGradient(colors: [CGColor]) {
        gradientLayer.colors = colors
    }
}
