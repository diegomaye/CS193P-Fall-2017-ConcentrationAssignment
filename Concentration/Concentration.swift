//
//  Concentration.swift
//  Concentration
//
//  Created by diegomaye on 2/10/19.
//  Copyright © 2019 Diego Maye. All rights reserved.
//

import Foundation
import GameplayKit

struct Concentration
{
    private(set) var cards = [Card]()
    
    private var scoringDate: Date?
    
    private(set) var score = 0
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter{ cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func chooseCard(at index: Int){
        assert(cards.indices.contains(index), "Concentration.choosenCard(\(index)): chsen index not in cards")
        if !cards[index].isMatched{
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index{
                //si las cartas coinciden
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            } else {
                //o no hay selecionada otra carta o las dos cartas estan seleccionadas
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int){
        initilizeDesk(numberOfPairsOfCards: numberOfPairsOfCards)
    }
    
    mutating func initilizeDesk(numberOfPairsOfCards: Int){
        //assert(cards.indices.contains(numberOfPairsOfCards), "Concentration.init(\(index)): you must have at least one pair of cards")
        //El _ sirve para decir que no se va a utilizar
        for _ in 1...numberOfPairsOfCards{
            let card = Card()
            cards += [card, card]
        }
        //TODO: Shuffle the cards
        cards = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: cards) as! [Card]
    }
    
    private mutating func increaseScore() {
        
        // The following Theme code is part of one of the extra credit tasks.
        // MARK: Extra credit 2
        // -------------------------
        if let scoringDate = scoringDate {
            let secondsBetweenFlips = Int(Date().timeIntervalSince(scoringDate))
            
            if secondsBetweenFlips < 2 {
                score += 3
            } else {
                score += 2
            }
            self.scoringDate = nil
        } else {
            score += 2
        }
        // -------------------------
    }
    
    /// Penalizes the player by one point.
    private mutating func penalize() {
        score -= 1
    }
    
    mutating func resetGame() {
        Card.resetIdentifiersFactory()
        cards = []
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
