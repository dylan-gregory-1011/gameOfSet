//
//  ViewController.swift
//  gameOfSet
//
//  Created by Dylan Smith on 1/31/18.
//  Copyright © 2018 Me. All rights reserved.
//

import UIKit


class SetViewController: UIViewController {
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Adds a shuffle gesture to the view
        let shuffleCardsGesture = UIRotationGestureRecognizer(target: self, action: #selector(reshuffleCards(_:)))
        self.view.addGestureRecognizer(shuffleCardsGesture)
        /// Adds a draw more cards gesture to the deck object
        let drawMoreCardsGesture = UITapGestureRecognizer(target:self, action:#selector(drawThreeCards(_:)))
        self.deckButton.addGestureRecognizer(drawMoreCardsGesture)
        /// Initializes all of the view properties.
        scoreBoard.layer.cornerRadius = Constants.cornerRadius
        scoreBoard.clipsToBounds = Constants.clipsToBounds
        deckButton.layer.cornerRadius = Constants.cornerRadius
        deckButton.clipsToBounds = Constants.clipsToBounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //restart the game and clean up the UI when you transition
        game = soloSet()
        updateScoreboard()
        for subview in self.view.subviews {
            if let cardSubview = subview as? CardOfSet {
                cardSubview.removeFromSuperview()
            }
        }
        dealCards(initial:true)
    }
    
    override func viewDidLayoutSubviews() {
        updateViewFromModel()
    }
    
    // MARK: - Properties
    private var gridOfCards: Grid! /// this intializes the grid of cards that allows the cards to be separated on the screen
    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var cardBehavior = CardBehavior(in: animator) /// The dynamic animator for the card
    private lazy var game = soloSet() /// initialize the game of set
    
    // MARK: - Outlets
    @IBOutlet weak var scoreBoard: UILabel!
    @IBOutlet weak var deckButton: UIButton!
    @IBOutlet weak var cardsInScreen: UIView! /// the view in which all the cards are held
    
    // MARK: - Object Interaction
    
    /**
        The function that animates when the user "selects" a card.  If the card hasn't been selected it adds the card to the selected card array and gives it a yellow boundary and then checks if the cards are a set when there are three selected cards.  If it has been selected then it removes the yellow border and removes the card from the selected card array.
    */
    @objc func selectCard(_ recognizer:UITapGestureRecognizer){
        switch recognizer.state {
        case .ended: if let chosenCardView = recognizer.view as? CardOfSet {
            let cardValue = chosenCardView.card
            if game.selectedCards.contains(cardValue) {
                game.alterSelectedCards(for: cardValue, remove: true)
                chosenCardView.layer.borderColor = UIColor.clear.cgColor
            } else {
                game.alterSelectedCards(for: cardValue, remove: false)
                chosenCardView.layer.borderColor = #colorLiteral(red: 0.9505754113, green: 1, blue: 0, alpha: 1)
                if game.selectedCards.count == 3 {
                    threeCardsHaveBeenSelected()
                    }
                }
            }
        default: print("pass")
        }
    }
    
    /**
        Adds the shuffle card gesture to ensure that the cards get new indexs'
     */
    @objc func reshuffleCards(_ recognizer: UIRotationGestureRecognizer){
        if recognizer.state == .began {
            game.shuffleFaceUpCards()
            updateViewFromModel()
        }
    }
    
    /**
        Adds the gesture to draw three cards onto the board.
     */
    @objc func drawThreeCards(_ recognizer: UITapGestureRecognizer){
        switch recognizer.state {
        case .ended: dealCards(initial: false)
        default: print("pass")
        }
    }
}

// MARK: - Constants and Matrix Size
extension SetViewController {
    /// Sets the constants that will be used in the dealing animation and how the cards are displayed.
    private struct Constants {
        static let dealingTime: TimeInterval = 0.3
        static let setFoundTime: TimeInterval = 0.3
        static let cornerRadius: CGFloat = 3.0
        static let clipsToBounds: Bool = true
    }
    
    /// gets the matrix size based on the amount of cards
    private var getMatrixSize: (rows:Int, columns:Int ) {
        let countOfCards: Double = Double(game.faceUpCards.count)
        switch UIDevice.current.orientation {
        case .portrait :
            var  rows = 11, columns = 2
            if countOfCards <= 44 && countOfCards>22 {
                columns =  Int(ceil(countOfCards / 11))
            } else if countOfCards < 60 && countOfCards > 44 {
                columns = 4; rows = 15
            } else if countOfCards > 60 {
                columns = 5; rows = 16
            }
            return (rows, columns)
        case .landscapeLeft, .landscapeRight:
            var rows = 6, columns = 4
            if countOfCards > 24 && countOfCards <= 36 {
                columns =  Int(ceil(countOfCards / 6))
            } else if countOfCards > 37 && countOfCards <= 56 {
                columns = 7; rows = 8
            } else if countOfCards > 57 {
                columns = 8; rows = 11
            }
            return (columns, rows)
        default: break
        }
        return (0,0)
    }
}

// MARK: - Private Methods

extension SetViewController {
    /**
     Deal the cards and ensure that the cards are the correct size to display all the cards on the screen.  This function also animates the dealing of the card from the deck location to the card's location in the grid.
     
    - parameters:
     - Initial: If this is the inital card, draw 12 cards, if not, draw the last three cards of the deck which are the most recent cards that have been added
    */
    private func dealCards(initial: Bool) {
        var deck = [SetCard]()
        if initial {
            deck = game.faceUpCards
        } else {
            game.drawMoreCardsFromDeck()
            deck = Array(game.faceUpCards.suffix(3))
            updateViewFromModel()
        }
        
        for (deckIndex, card) in deck.enumerated() {
            let cardIndex = Int(game.faceUpCards.index(of: card)!)
            let cardView = CardOfSet(card: card, frame: CGRect(x: deckButton.superview!.frame.minX + deckButton.frame.minX ,y: deckButton.superview!.frame.minY, width: deckButton.bounds.width, height: deckButton.bounds.height ) , index: cardIndex)

            let gesture = UITapGestureRecognizer(target:self, action:#selector(selectCard(_:)))
            cardView.addGestureRecognizer(gesture)
            self.view.insertSubview(cardView, belowSubview: cardsInScreen)
            
            let dealingAnimator = UIViewPropertyAnimator(duration: Constants.dealingTime, curve: .easeInOut) { [unowned self] in
                cardView.changeFrame(frame: self.gridOfCards[cardIndex]!)
            }
            dealingAnimator.addCompletion { _ in
                self.view.bringSubview(toFront: cardView)
            }
            dealingAnimator.startAnimation(afterDelay:Constants.dealingTime*TimeInterval(deckIndex))
        }
    }
    
    /**
    If three cards are selected then check if the cards are a set.  If they are a set then animate the objects for a time and then snap them back to the bottom of the deck and re-arrange the cards.  If they aren't, remove them from the selected cards array and go on.
    */
    private func threeCardsHaveBeenSelected(){
        let cardsAreASet = game.checkIfCardsAreASet
        if cardsAreASet {
            game.increaseSetScore()
            updateScoreboard()
        }
        
        for subview in self.view.subviews {
            if let cardSubview = subview as? CardOfSet {
                let card = cardSubview.card
                if game.selectedCards.contains(card) && cardsAreASet {
                    self.view.bringSubview(toFront: cardSubview)
                    cardBehavior.addItem(cardSubview)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.cardBehavior.removeItem(cardSubview)
                        let finalAnimator = UIViewPropertyAnimator(duration: Constants.setFoundTime, curve: .easeInOut) { [unowned self] in
                            cardSubview.changeFrame(frame: CGRect(x: self.deckButton.superview!.frame.minX + self.deckButton.frame.minX ,y: self.deckButton.superview!.frame.minY, width: self.deckButton.bounds.width, height: self.deckButton.bounds.height ))
                        }
                        
                        finalAnimator.addCompletion { _ in
                            cardSubview.isHidden = true
                            cardSubview.alpha = 0
                            cardSubview.sendSubview(toBack: self.view)
                            self.game.cardsAreASetRemoveCard(for: card)
                            self.game.alterSelectedCards(for: card, remove: true)
                            if self.game.selectedCards.count == 0 {
                                self.updateViewFromModel()
                            }
                        }
                        finalAnimator.startAnimation()
                    }
                }
                cardSubview.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
    
    /**
        Everytime we update the view from model we change the frame to represent the most recent index and then change it
    */
    private func updateViewFromModel() {
        gridOfCards = Grid(layout: Grid.Layout.dimensions(rowCount: getMatrixSize.rows, columnCount: getMatrixSize.columns), frame: cardsInScreen.frame)
        
        for subview in self.view.subviews {
            if let cardSubview = subview as? CardOfSet {
                if let cardIndex = game.faceUpCards.index(of: cardSubview.card)  {
                    cardSubview.changeFrame(frame: gridOfCards[cardIndex]!)
                    cardSubview.indexInScreen = cardIndex
                }
            }
        }
    }
    
    /**
        updates the scoreboard whenever a set is found.
    */
    private func updateScoreboard() {
        let attributes: [NSAttributedStringKey:Any] = [
            .foregroundColor: UIColor.red
        ]
        let attributedString = NSAttributedString(string: "Sets: \(game.score)", attributes: attributes)
        scoreBoard.attributedText = attributedString
    }
}
