//
//  soloSet.swift
//  gameOfSet
//
//  Created by Dylan Smith on 1/31/18.
//  Copyright © 2018 Me. All rights reserved.
//

import Foundation

// TODO: Comment and re-organize this object
struct soloSet {
    var allCards = [SetCard](), allCardsSplit = [[SetCard]]() , cardsInDeck = [SetCard](), faceUpCards = [SetCard](), selectedCards = [SetCard]()
    
    private(set) var score: Int = 0 
    //try get->set variables for selected cards and face up cards
    mutating func alterSelectedCards(for card: SetCard, remove: Bool) {
        if remove {
            selectedCards = selectedCards.filter {$0 != card}
        } else {
            selectedCards.append(card)
        }
    }
    
    var checkIfCardsAreASet: Bool  {
        if  (Set(selectedCards.map ({ $0.shape })).count == 2 || Set(selectedCards.map({ $0.shading })).count == 2 || Set(selectedCards.map({ $0.color })).count == 2 || Set(selectedCards.map({ $0.amountOfSymbols })).count == 2) && selectedCards.count == 3 {
            return false
        } else {
            return true
        }
    }
    
    mutating func shuffleFaceUpCards() {
        faceUpCards = faceUpCards.shuffled()
    }
    
    mutating func cardsAreASetRemoveCard(for card: SetCard) {
        faceUpCards = faceUpCards.filter {$0 != card}
    }
    
    mutating func increaseSetScore() {
        score += 1
    }
    
    mutating func drawMoreCardsFromDeck() {
        var iterations = 0
        
        while iterations < 3 && cardsInDeck.count > 0 {
            faceUpCards += [cardsInDeck.remove(at: cardsInDeck.startIndex)]
            iterations+=1
        }
    }
    
    init() {
        score = 0
        //iterate through all possible combinations and add to the allCards array
        for color in SetCard.Color.all {
            for shape in SetCard.Shape.all{
                for shading in SetCard.Shading.all{
                    for numberOfSymbols in SetCard.AmountOfSymbols.all{
                        allCards.append(SetCard(color: color, shape: shape, shading: shading, amountOfSymbols: numberOfSymbols))
                    }
                }
            }
        }

        //shuffle the cards, allocate 12 cards in the initial faceUpCards and the rest in the deck
        allCardsSplit = allCards.shuffled().split(numberOfFirstSplit: 12)
        faceUpCards = allCardsSplit[0]
        cardsInDeck = allCardsSplit[1]
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}

extension Array {
    //this function splits the array based on the amount of elements in the first array, returns two arrays.
    func split(numberOfFirstSplit:Int) -> [[Element]] {
        let ct = self.count
        let firstSplit = self[0..<numberOfFirstSplit]
        let secondSplit = self[numberOfFirstSplit..<ct]
        return [Array(firstSplit),Array(secondSplit)]
    }
    //returns a shuffled array
    func shuffled() -> [Iterator.Element] {
        var list = self
        list.shuffle_list()
        return list
    }
}

extension MutableCollection where Index == Int{
    //shuffles the cards based on the index and makes its way through the array and randomly swaps with swapAt
    mutating func shuffle_list() {
        let c = self.count
        guard c > 1 else { return }
        
        for cardIndex in self.indices{
            let randomCardIndex = Int(c).arc4random
            swapAt(randomCardIndex, cardIndex)
        }
    }
}

