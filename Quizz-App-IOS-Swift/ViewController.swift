//
//  ViewController.swift
//  Quizz-App-IOS-Swift
//
//  Created by Mehdi Benrefad on 04/04/2021.
//  Copyright © 2021 Mehdi Benrefad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //@IBOutlet weak var newGameButton: UIButton!
    
    @IBOutlet weak var newGameButton: UIButton!
    
    //@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //@IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    @IBOutlet weak var questionView: QuestionView!
    

    var game = Game()

    //une fois le controlleur demare cette methode est appelee
    override func viewDidLoad() {
        super.viewDidLoad()

        newGameButton.layer.cornerRadius=25.0

        //ici on recuoere la notification envoyee par le modele
        //et on fait appel a la fonction questionloaded
        let name = Notification.Name(rawValue: "QuestionsLoaded")
        NotificationCenter.default.addObserver(self, selector: #selector(questionsLoaded), name: name, object: nil)

        //on lance un nouveau game des que les questions sont chargees
        startNewGame()

        //ici on fait un listener sur la position de notre question view et on fait appel a la fonction dragquestionview()
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView(_:)))
        questionView.addGestureRecognizer(panGestureRecognizer)
    }
/*
    @IBAction func didTapNewGameButton() {
        startNewGame()
    }
 */
    
    //on ajoute un listener sur le bouton new game
    @IBAction func didTapNewGameButton() {
        startNewGame()
        
    }
    
    
    //la fonction qui demare un nouveau jeu
    private func startNewGame() {
        activityIndicator.isHidden = false
        newGameButton.isHidden = true

        questionView.title = "Loading..."
        questionView.style = .standard

        scoreLabel.text = "0 / 10"

        game.refresh()
    }

    @objc func questionsLoaded() {
        activityIndicator.isHidden = true
        newGameButton.isHidden = false
        questionView.title = game.currentQuestion.title
    }

    @objc func dragQuestionView(_ sender: UIPanGestureRecognizer) {
        if game.state == .ongoing {
            switch sender.state {
            case .began, .changed:
                //dans le cas de debut de changement
                transformQuestionViewWith(gesture: sender)
            case .ended, .cancelled:
                // dans le cas de la reponse
                answerQuestion()
            default:
                break
            }
        }
    }

    private func transformQuestionViewWith(gesture: UIPanGestureRecognizer) {
        
        //operation de translation
        let translation = gesture.translation(in: questionView)

        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y)

        //pourcentage de translation
        let translationPercent = translation.x/(UIScreen.main.bounds.width / 2)
        //calcule de l'angle de rotation a effectuer en fonction de la translation
        let rotationAngle = (CGFloat.pi / 3) * translationPercent
        //la  transformation de rotation
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle)

        //concatener la translation et la rotation
        let transform = translationTransform.concatenating(rotationTransform)
        //application de  la transformation
        questionView.transform = transform

        //application du style au questionView apres la transformation
        if translation.x > 0 {
            questionView.style = .correct
        } else {
            questionView.style = .incorrect
        }
    }

    private func answerQuestion() {
        
        switch questionView.style {
        case .correct:
            game.answerCurrentQuestion(with: true)
        case .incorrect:
            game.answerCurrentQuestion(with: false)
        case .standard:
            break
        }
        
        
        // on change le score par celui qui est a jour dans notre seule instance game dans l'application
        scoreLabel.text = "\(game.score) / 10"

        //on recupere la largeur de l'ecran
        let screenWidth = UIScreen.main.bounds.width
        //on declare une transformation de translation
        var translationTransform: CGAffineTransform
        if questionView.style == .correct {
            //translation avec un x positif
            translationTransform = CGAffineTransform(translationX: screenWidth, y: 0)
        } else {
            //translation avec un x negatif
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
        }

        // Une animation pour faire bouger le question view vers la droite ou vers la gauche de l'ecran.
        UIView.animate(withDuration: 0.3, animations: {
            self.questionView.transform = translationTransform
        }, completion: { (success) in
            if success {
                self.showQuestionView()
            }
        })
    }

    private func showQuestionView() {
        questionView.transform = .identity
        
        //cette transformation pour reduir la taille de questionView avant de l'agrandir avec anmation
        questionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)

        questionView.style = .standard

        switch game.state {
        case .ongoing:
            questionView.title = game.currentQuestion.title
        case .over:
            questionView.title = "Game Over"
        }
        
        //Cette animation sert a agrandir notre notre question view et le faire osciller quand il s'approche de sa taille normale (De depart == Standard)
        //pour ce faire on utilise une autre version de animate()
        //duration: pour la duree de l'animation.
        //delay: pour decaler le demarage de l'aniation.
        //initialSpringVelocity: la vitesse de depart de la vue lors de l'animation, plus elle sera rapide plus les oscillations seront grands.
        //usingSpringWithDamping: plus qu'on est proche de 0 plus qu'on a des oscillations.
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.questionView.transform = .identity
        }, completion:nil)
    }
}

