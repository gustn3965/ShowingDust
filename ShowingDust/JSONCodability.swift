//
//  JSONCodability.swift
//  ShowingDust
//
//  Created by hyunsu on 2021/05/03.
//

import Foundation

func jsonDecoder<T: Decodable>(type: T.Type, data: Data)  throws -> T   {
    return try JSONDecoder().decode(type, from: data)
}

func jsonEncoder<T: Codable>(value: T) throws -> Data {
    return try JSONEncoder().encode(value)
}
