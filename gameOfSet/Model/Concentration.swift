//
//  Concentration.swift
//  gameOfSet
//
//  Created by Dylan Smith on 3/24/18.
//  Copyright © 2018 Me. All rights reserved.
//

import Foundation
// TODO: Comment and re-organize this object
struct Concentration
{
    //creates an empty array of type Card and also a shuffled array of cards.  Initializes the game score as well.
    private(set) var cards = [Card](), cardsShuffled = [Card]()
    private(set) var gameScore = 0, flipCount = 0
    

    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cardsShuffled.indices.filter {cardsShuffled[$0].isFaceUp}.oneAndOnly
        }
        set {
            for index in cardsShuffled.indices {
                cardsShuffled[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    //The mutating function means that the function is allowed to change the cards array.  The assert function makes sure a specific quality is true and if it is false it throws an error.
    mutating func chooseCard(at index: Int){
        assert(cardsShuffled.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        flipCount+=1
        //if the card is not matched at the index, and if matchIndex is not equal to the index then check if the card you just pulled is equal to the card that is face up.
        if !cardsShuffled[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard , matchIndex != index {
                //if the cards match then set them to isMatched and add two to the gameScore
                if cardsShuffled[matchIndex] == cardsShuffled[index] {
                    cardsShuffled[matchIndex].isMatched = true
                    cardsShuffled[index].isMatched = true
                    gameScore += 2
                }
                else {
                    //subtract the values from the gamescore
                    if cardsShuffled[matchIndex].previouslyFlippedOver {gameScore -= 1}
                    else if cardsShuffled[index].previouslyFlippedOver {gameScore -= 1}
                    
                    //set the previously flipped over value to true
                    for nextIndex in cardsShuffled.indices {
                        if cardsShuffled[nextIndex] == cardsShuffled[index], nextIndex != index {
                            cardsShuffled[index].previouslyFlippedOver = true
                            cardsShuffled[nextIndex].previouslyFlippedOver = true
                        }
                    }
                }
                //set the both cards to be up.
                cardsShuffled[index].isFaceUp = true
            } else {
                //if the card is not matching then set the index of the only card that is face up to the new index
                indexOfOneAndOnlyFaceUpCard = index
                
            }
        }
    }
    
    //initialize the game of Concentration with an input of the amount of Pairs of Cards. We need to assert that the number of pairs of cards in each is positive.
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards>0, "Concentration.init(at: \(numberOfPairsOfCards)): must be at least one card")
        //for the amount of cards that will be used. iterate through the amount of distinct emojis.  For each of the pairs, create a new instance of the type Card for each iteration and place two copies of this instance
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        //shuffle the cards
        for _ in cards.indices {
            let randomCardsIndex = cards.index(cards.startIndex, offsetBy: cards.count.arc4random)
            cardsShuffled += [cards.remove(at: randomCardsIndex)]
        }
        //reset the Game Theme array at the beginning of every array
        
    }
}

//this extension extends the class collection and adds a variable of type element that checks if there is only one element in the array.  If there is only 1, return the first element, if there is more then 1, it is nil.
extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
