//
//  ConcentrationViewController.swift
//  gameOfSet
//
//  Created by Dylan Smith on 3/24/18.
//  Copyright © 2018 Me. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateFlipCountLabel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateViewFromModel()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        flipCountLabel.layer.cornerRadius = 3.0
        flipCountLabel.clipsToBounds = true
        cardButtons.forEach {$0.layer.cornerRadius = 3.0 }
        cardButtons.forEach {$0.clipsToBounds = true }
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }
    
    // MARK: - Properties
    
    /// A dictionary that has a Card type as a key and a String type as a value and dictates the emojis
    private var emoji = [Card:String]()
    /// Initializes an instance of the game concentration with the correct number of cards
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    /// This variable determines how many pairs of cards need to be created
    var numberOfPairsOfCards: Int { return visibleCardButtons.count / 2 }
    // sets the theme string and everytime this variable gets set the model is updated.
    var theme: String? {
        didSet {
            gameEmojis = theme ?? ""
            emoji = [:]
            updateViewFromModel()
            }
        }
    
    //game theme array with emojis, colors and backgrounds. Don't need to initialize
    //set the emojis, game theme and colors
    var gameThemeColor: UIColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
    var gameThemeBackground : UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    var gameEmojis: String = "💩🤢🤮🤬😈🤧🧟‍♀️🧛‍♀️🤥"
    
    /// The property that helps hide card buttons that aren't visible.
    private var visibleCardButtons: [UIButton]! {
            return cardButtons?.filter {!$0.superview!.isHidden}
        }
    
    // MARK: - Outlets
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var flipCountLabel: UILabel!
    /// This outlet action dictates how the model reacts if the card is selected
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = visibleCardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
            updateFlipCountLabel()
        } else { print("card was not in the buttons") }
    }
}

// MARK: - Private Methods
extension ConcentrationViewController {
    /// This method takes a Card type input and returns a string.
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil , gameEmojis.count > 0 {
            let randomStringIndex = gameEmojis.index(gameEmojis.startIndex, offsetBy: gameEmojis.count.arc4random)
            emoji[card] = String(gameEmojis.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
    
    /// This function updates the flip count labe to show how many cards have been flipped.
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedStringKey:Any] = [
            .foregroundColor : gameThemeColor
        ]
        let attributedString = NSAttributedString(
            string: traitCollection.verticalSizeClass == .compact ? "Flips\n\(game.flipCount)" : "Flip: \(game.flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    /// The updateViewFromModel function updates the view and shows which cards are face up.
    private func updateViewFromModel(){
        self.view.backgroundColor = gameThemeBackground
        
        if cardButtons != nil {
            for index in visibleCardButtons.indices {
                let button = visibleCardButtons[index]
                let card = game.cardsShuffled[index]
                if card.isFaceUp {
                    button.setTitle(emoji(for: card), for: UIControlState.normal)
                    button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                } else {
                    button.setTitle(" ", for: UIControlState.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : gameThemeColor
                }
            }
        }
    }
}
