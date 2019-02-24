//
//  ViewController.swift
//  Concentration
//
//  Created by diegomaye on 2/9/19.
//  Copyright © 2019 Diego Maye. All rights reserved.
//

import UIKit

enum Theme: Int{
    
    case Countries, Faces, Sports, Halloween
    
    var cardColor: UIColor {
        switch self {
        case .Countries:
           return #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        case .Faces:
            return #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        case .Sports:
            return #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        case .Halloween:
            return #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        }
    }
        
    var backGroundColor: UIColor{
        switch self {
        case .Countries:
            return #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        case .Faces:
            return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        case .Sports:
            return #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        case .Halloween:
            return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
    }
        
    var emoji: String{
        switch self {
            case .Countries:
                return "🇺🇾🇦🇷🇧🇷🇫🇷🇺🇸🇲🇽🇨🇦🇮🇹"
            case .Faces:
                return "🥰🥳🥴🥶🥺😊😜🤣"
            case .Sports:
                return "🏊‍♀️🏄🏻‍♀️🚴🏼‍♀️⛹🏽‍♀️🚣🏿‍♀️🏄‍♂️🤽🏼‍♂️🏌🏾‍♂️"
            case .Halloween:
                return "🐉🧛‍♂️👿🐲👻🎃👺👹"
        }
    }

    static var count: Int {
        return Theme.Halloween.rawValue + 1
    }
    
    static func getRandomTheme() -> Theme {
        return Theme(rawValue: Theme.count.arc4random)!
    }
}

class ViewController: UIViewController {
    
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet private weak var flipCountLabel: UILabel!{
        didSet{
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    //lazy hace que se inicie cuando se utiliza por primera vez,
    //no se puede utilizar el didSet
    private lazy var game: Concentration = Concentration(numberOfPairsOfCards: numberOfPairOfCards)
    
    var numberOfPairOfCards: Int{
        return (cardButtons.count + 1)/2;
    }
    
    private var flipCount = 0 {
        didSet{
            updateFlipCountLabel()
        }
    }
    
    private var score = 0 {
        didSet{
            updateScoreLabel()
        }
    }
    
    private var emojiChoices: String = "";
    
    private var emoji = [Card:String]()
    
    private var themeChoosed:Theme!
    
    override func viewDidLoad() {
        loadGame()
    }
    
    private func updateFlipCountLabel(){
        let attributes : [NSAttributedString.Key:Any] = [
            .strokeWidth:5.0,
            .strokeColor: #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    private func updateScoreLabel(){
        let attributes : [NSAttributedString.Key:Any] = [
            .strokeWidth:5.0,
            .strokeColor: #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Score: \(score)", attributes: attributes)
        scoreLabel.attributedText = attributedString
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender){
            if !game.cards[cardNumber].isMatched {
                flipCount += 1
            }
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chose card was not in cardButtons")
        }
    }
    
    @IBAction private func newGame(_ sender: UIButton) {
        loadGame()
        resetGame()
        updateViewFromModel()
        reloadLabels()
    }
    
    private func emoji(for card: Card) -> String{
        if emoji[card] == nil, Theme.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
    
    private func loadGame(){
        themeChoosed = Theme.getRandomTheme();
        view.backgroundColor = themeChoosed.backGroundColor
        emoji = [:]
        emojiChoices = themeChoosed.emoji
        
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        for (index, cardButton) in cardButtons.enumerated() {
            guard game.cards.indices.contains(index) else { continue }
            
            let card = game.cards[index]
            
            if card.isFaceUp {
                cardButton.setTitle(emoji(for: card), for: .normal)
                cardButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                cardButton.setTitle("", for: .normal)
                cardButton.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : themeChoosed.cardColor
            }
        }
    }
    
    private func reloadLabels() {
        flipCountLabel.text = "Flips: \(flipCount)"
        scoreLabel.text = "Score: \(score)"
    }
    
    private func resetGame(){
        flipCount = 0
        score = 0
        game.resetGame()
        game.initilizeDesk(numberOfPairsOfCards: numberOfPairOfCards)
    }
    
}

extension Int {
    var arc4random : Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0;
        }
    }
}
