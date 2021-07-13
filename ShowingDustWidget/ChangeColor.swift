//
//  ChangeColor.swift
//  ShowingDustWidgetExtension
//
//  Created by hyunsu on 2021/07/12.
//

import SwiftUI

func changeBackgroundColor(by value: String ) -> [Color] {
    guard let value = Int(value) else {
        return [Color(#colorLiteral(red: 0.22, green: 0.24, blue: 0.27, alpha: 1.00).cgColor),Color(#colorLiteral(red: 0.83, green: 0.25, blue: 0.00, alpha: 1.00).cgColor)]
    }
    switch value {
    case 0..<31 :
        return [Color(#colorLiteral(red: 0.24, green: 0.86, blue: 0.94, alpha: 1.00).cgColor),Color( #colorLiteral(red: 0.78, green: 1.00, blue: 0.76, alpha: 1.00).cgColor)]
    case 31..<71:
        return [Color(#colorLiteral(red: 0.24, green: 0.86, blue: 0.94, alpha: 1.00).cgColor), .orange]
    case 71..<101:
        return [Color(#colorLiteral(red: 0.87, green: 0.54, blue: 0.44, alpha: 1.00).cgColor),Color(#colorLiteral(red: 0.83, green: 0.25, blue: 0.00, alpha: 1.00).cgColor)]
    default:
        return [Color(#colorLiteral(red: 0.22, green: 0.24, blue: 0.27, alpha: 1.00).cgColor),Color(#colorLiteral(red: 0.83, green: 0.25, blue: 0.00, alpha: 1.00).cgColor)]
    }
}
