//
//  Card.swift
//  gameOfSet
//
//  Created by Dylan Smith on 2/1/18.
//  Copyright © 2018 Me. All rights reserved.
//

import Foundation

struct SetCard {
    // MARK: - Properties
    var color : Color
    var shape : Shape
    var shading : Shading
    var amountOfSymbols : AmountOfSymbols
    
    // MARK: - Enum's and New Types
    enum Color: Int {
        case colorOne = 0
        case colorTwo = 1
        case colorThree = 2
        
        static var all = [Color.colorOne,.colorTwo, .colorThree ]
    }
    
    enum Shape: Int {
        case shapeOne = 0
        case shapeTwo = 1
        case shapeThree = 2
        
        static var all = [Shape.shapeOne, .shapeTwo, .shapeThree]
    }
    
    enum Shading: Int {
        case shadingOne = 0
        case shadingTwo = 1
        case shadingThree = 2
        
        static var all = [Shading.shadingOne, .shadingTwo, .shadingThree]
    }
    
    enum AmountOfSymbols: Int {
        case one = 1
        case two = 2
        case three = 3
        
        static var all = [AmountOfSymbols.one, .two, .three]
    }
    
}

// Mark: - Make Card Equatable
extension SetCard: Equatable {
    static func == (lhs:SetCard, rhs:SetCard) -> Bool {
        return lhs.color == rhs.color && lhs.shape == rhs.shape && lhs.shading == rhs.shading && lhs.amountOfSymbols == rhs.amountOfSymbols
    }
}


