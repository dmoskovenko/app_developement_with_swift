//
//  ViewController.swift
//  Apple Pie
//
//  Created by Dmitry on 20/11/2020.
//  Copyright © 2020 Dmitry Moskovenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    newGame()
  }

  @IBOutlet var treeImageView: UIImageView!
  @IBOutlet var letterButtons: [UIButton]!
  @IBOutlet var currentWordLabel: UILabel!
  @IBOutlet var scoreLabel: UILabel!
  @IBAction func buttonTapped(_ sender: UIButton) {
    sender.isEnabled = false
    let letterString = sender.title(for: .normal)!
    let letter = Character(letterString.lowercased())
    currentGame.playerGuessed(letter: letter)
    updateGameState()
  }
  
  var listOfWords = ["brother", "country", "education", "example"]
  let incorrectMovesAllowed = 7
  var totalWins = 0 {
    didSet {
      changeBackgroundColor(true)
      newRound()
    }
  }
  var totalLosses = 0 {
    didSet {
      changeBackgroundColor(false)
      newRound()
    }
  }
  var currentGame: Game!
  
  func newGame() {
    listOfWords.shuffle()
    newRound()
  }
  
  func newRound() {
    if !listOfWords.isEmpty {
      let newWord = listOfWords.removeFirst()
      currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectMovesAllowed, guessedLetters: [])
      enableLetterButtons(true)
    } else {
      enableLetterButtons(false)
    }
    updateUI()
  }
  
  func enableLetterButtons(_ enable: Bool) {
    for button in letterButtons {
      button.isEnabled = enable
    }
  }
  
  func updateGameState() {
    if currentGame.incorrectMovesRemaining == 0 {
      totalLosses += 1
    } else if currentGame.word == currentGame.formattedWord {
      totalWins += 1
    } else {
      updateUI()
    }
  }
  
  func changeBackgroundColor(_ win: Bool) {
    let seconds = 0.1
    UIView.animate(withDuration: 0.2) {
      self.view.backgroundColor = win ? .green : .red
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
      UIView.animate(withDuration: 1) {
        self.view.backgroundColor = .white
      }
    }
  }
  
  func updateUI() {
    var letters = [String]()
    for letter in currentGame.formattedWord {
      letters.append(String(letter))
    }
    let wordWithSpacing = letters.joined(separator: " ")
    UIView.transition(with: currentWordLabel, duration: 0.4, options: .transitionCrossDissolve, animations: { self.currentWordLabel.text = wordWithSpacing }, completion: nil)
    UIView.transition(with: scoreLabel, duration: 0.4, options: .transitionCrossDissolve, animations: { self.scoreLabel.text = "Wins: \(self.totalWins)            Losses: \(self.totalLosses)" }, completion: nil)
    UIView.transition(with: treeImageView, duration: 0.6, options: .transitionCrossDissolve, animations: { self.treeImageView.image = UIImage(named: "Tree \(self.currentGame.incorrectMovesRemaining)") }, completion: nil)
  }
}
