//
//  Game.swift
//  Quizz-App-IOS-Swift
//
//  Created by Mehdi Benrefad on 04/04/2021.
//  Copyright © 2021 Mehdi Benrefad. All rights reserved.
//


import Foundation


class Game {
    var score = 0
    var state: State = .ongoing

    enum State {
        case ongoing, over
    }

    private var questions = [Question]()
    private var currentIndex = 0

    var currentQuestion: Question {
        return questions[currentIndex]
    }

    func refresh() {
        score = 0
        currentIndex = 0
        state = .over
        
            //Ici on applique le design pattern singleton[shared]
            //On a un seule instance partagee de la classe QuestionManager.
        
            //methode1:on fait apel a une fonction
            //QuestionManager.shared.get(completionHandler: receiveQuestions)
        
            //methode2
            //on peut remplacer la fonction recieve questions avec une fermeture comme suit:
            QuestionManager.shared.get { (questions) in
            self.questions = questions
            self.state = .ongoing
            let name = Notification.Name(rawValue: "QuestionsLoaded")
            let notification = Notification(name: name)
            NotificationCenter.default.post(notification)
        }
    }
    /*
    private func receiveQuestions(_ questions: [Question]) {
        self.questions = questions
        print(questions)
        self.state = .ongoing
        let name = Notification.Name(rawValue: "QuestionsLoaded")
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
        
    }*/
    func answerCurrentQuestion(with answer: Bool) {
        if (currentQuestion.isCorrect && answer) || (!currentQuestion.isCorrect && !answer) {
            score += 1
        }
        goToNextQuestion()
    }

    private func goToNextQuestion() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
        } else {
            finishGame()
        }
    }

    private func finishGame() {
        state = .over
    }
}
