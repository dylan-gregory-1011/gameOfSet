//
//  Card.swift
//  gameOfSet
//
//  Created by Dylan Smith on 3/24/18.
//  Copyright © 2018 Me. All rights reserved.
//

import Foundation
// TODO: Comment and re-organize this object

//this delcares the struct Card, ensures it is hashable, and allows for instances of the type card to be created
struct Card: Hashable
{
    var hashValue: Int {return identifier}
    //declares a function == that allows the user to check if two card are equal.
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    //initializes each card as face down and not matched.  Also sets identifier to a number that is an int
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    var previouslyFlippedOver = false
    
    //sets the first identifier value at 0
    private static var identifierFactory = 0
    
    //allows for the identifier to increment by one each time a Card type is initialized.
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    //initializes a Card type and assigns the unique identifier to increment as +1 each time it is called.
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
