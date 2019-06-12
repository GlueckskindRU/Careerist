//
//  AnswerQuestionsTableViewController.swift
//  BusarovaCoaching
//
//  Created by Yuri Ivashin on 10/01/2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

protocol SubmitedAnswersProcessingProtocol {
    func preceedWithSubmittedAnswers()
}

class AnswerQuestionsTableViewController: UITableViewController {
    private var articleID: String = ""
    private var competenceId: String = ""
    private var article: Article?
    private var questionsInsideArray: [ArticleInside] = []
    private var answersOptions: [String] = []
    private var activityIndicator = ActivityIndicator()
    private var sequence: Int = 0
    private var correctAnswers: Set<Int> = []
    private var usersAnswers: Set<Int> = []
    private let separator: Character = "|"
    private var question: String = ""
    private var totalPoints: Int = 0
    private var questionAlreadyPassed = false
    private var snozzedTime: Date = Date()
    
    lazy private var customBackButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(named: Assets.backArrow.rawValue),
                               style: UIBarButtonItem.Style.plain,
                               target: self,
                               action: #selector(customBackButtonTapped(_:))
        )
    }()
    
    lazy private var showNextQuestionBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Следующий вопрос", style: .plain, target: self, action: #selector(showNextQuestionButtonTapped(_:)))
    }()
    
    lazy private var backToArticleBarButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.reply,
                               target: self,
                               action: #selector(goBackToArticleButtonTapped(_:))
                                )
    }()
    
    func configure(with articleID: String, as sequence: Int, totalPoints: Int, competenceId: String, article: Article) {
        self.articleID = articleID
        self.sequence = sequence
        self.totalPoints = totalPoints
        self.competenceId = competenceId
        self.article = article
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(AnswersCell.self, forCellReuseIdentifier: CellIdentifiers.answersOptionCell.rawValue)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.separatorStyle = .none
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = customBackButton
        navigationItem.rightBarButtonItems = [backToArticleBarButton]
        
        fetchQuestions()
        
        tableView.tableFooterView = UIView()
        
        navigationItem.title = article?.title
    }
    
    override  func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.allowsMultipleSelection = self.correctAnswers.count > 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let tintColor = UIColor(named: "cabinetTintColor") {
            navigationController?.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: tintColor,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.heavy)
            ]
        }
        
        setupNavigationMultilineTitle()
        tableView.reloadData()
    }
}

// MARK: - TableView DataSource
extension AnswerQuestionsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answersOptions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.answersOptionCell.rawValue, for: indexPath) as! AnswersCell
        
        cell.configure(with: answersOptions[indexPath.row])
        let customColorView = UIView()
        customColorView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = customColorView
        
        return cell
    }
}

//MARK: TableView Delegate
extension AnswerQuestionsTableViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let xibView = UINib(nibName: String(describing: QuestionView.self), bundle: nil)
        let headerView = xibView.instantiate(withOwner: nil, options: nil).first as! QuestionView
        
        headerView.configure(with: question, sequence: self.sequence + 1, total: questionsInsideArray.count, multipleSelection: correctAnswers.count > 1)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let xibView = UINib(nibName: String(describing: SubmitAnswersView.self), bundle: nil)
        let footerView = xibView.instantiate(withOwner: nil, options: nil).first as! SubmitAnswersView
        
        footerView.configure(with: self,
                             questionAlreadyPassed: questionAlreadyPassed,
                             snoozedTill: snozzedTime <= Date() ? nil : snozzedTime
                            )
        
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        usersAnswers.insert(indexPath.row)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = UITableViewCell.AccessoryType.checkmark
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if usersAnswers.contains(indexPath.row) {
            usersAnswers.remove(indexPath.row)
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = UITableViewCell.AccessoryType.none
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if questionAlreadyPassed && correctAnswers.contains(indexPath.row) {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
    }
}

extension AnswerQuestionsTableViewController {
    private func fetchQuestions() {
        if articleID == "", competenceId == "" {
            return
        }
        
        guard let currentUser = (UIApplication.shared.delegate as! AppDelegate).appManager.getCurrentUser() else {
            return
        }
        
        activityIndicator.start()
        
        FirebaseController.shared.getDataController().fetchArticle(with: articleID, forPreview: false) {
            (result: Result<[ArticleInside]>) in
            
            if result.isSuccess, let articleInsideArray = result.value {
                self.questionsInsideArray = articleInsideArray.filter { $0.type == ArticleInsideType.testQuestion }
                if let correctAnswers = self.questionsInsideArray[self.sequence].caption {
                    self.correctAnswers = Set(correctAnswers.split(separator: self.separator).map { Int($0) }) as! Set<Int>
                }
                
                if let answers = self.questionsInsideArray[self.sequence].listElements {
                    self.answersOptions = answers
                }
                
                if let text = self.questionsInsideArray[self.sequence].text {
                    self.question = text
                }
                
                if self.questionsInsideArray.count > 1 {
                    self.navigationItem.rightBarButtonItems?.insert(self.showNextQuestionBarButtonItem, at: 0)
                }
                
                if self.questionsInsideArray.count == self.sequence + 1 {
                    self.showNextQuestionBarButtonItem.isEnabled = false
                }
                
                self.tableView.allowsMultipleSelection = self.correctAnswers.count > 1
                
                for rating in currentUser.rating {
                    if rating.competenceID == self.competenceId {
                        for detail in rating.details {
                            if detail.questionID == self.questionsInsideArray[self.sequence].id {
                                self.questionAlreadyPassed = detail.passed
                                if !detail.passed, let snoozedTill = detail.snoozedTill {
                                    self.snozzedTime = snoozedTill
                                }
                            }
                        }
                    }
                }
            }
            
            self.tableView.reloadData()
            
            self.activityIndicator.stop()
        }
    }
    
    @objc
    private func showNextQuestionButtonTapped(_ sender: UIBarButtonItem) {
        guard let article = article else {
            return
        }
        
        let nextQuestionVC = AnswerQuestionsTableViewController()
        
        nextQuestionVC.configure(with: articleID, as: sequence + 1, totalPoints: totalPoints, competenceId: competenceId, article: article)
        
        navigationController?.pushViewController(nextQuestionVC, animated: true)
    }
    
    @objc
    private func goBackToArticleButtonTapped(_ sender: UIBarButtonItem) {
        guard let count = navigationController?.viewControllers.count else {
            return
        }
        
        let index = count - sequence - 2
        
        guard let destinationVC = navigationController?.viewControllers[index] else {
            return
        }
        
        navigationController?.popToViewController(destinationVC, animated: true)
    }
    
    private func updateUserWithProgress() {
        guard var currentUser = (UIApplication.shared.delegate as! AppDelegate).appManager.getCurrentUser() else {
            return
        }
        
        activityIndicator.start()
        
        let questionID = questionsInsideArray[sequence].id
        
        questionAlreadyPassed = true
        
        var newDetails: Set<PassedQuestions.Details> = [PassedQuestions.Details(questionID: questionID, passed: true, snoozedTill: nil)]
        var oldRating: PassedQuestions?
        var newRating = PassedQuestions(competenceID: competenceId, earnedPoints: answersOptions.count, totalPoints: totalPoints, details: newDetails)
        
        let userRatings = currentUser.rating
        
        for rating in userRatings {
            if rating.competenceID == competenceId {
                oldRating = rating
                newDetails = getUpdatedDetails(currentDetails: rating.details, passed: true, snoozedTime: nil)
                newRating = PassedQuestions(competenceID: competenceId, earnedPoints: rating.earnedPoints + answersOptions.count, totalPoints: totalPoints, details: newDetails)
                break
            }
        }
        
        if let oldRating = oldRating {
            currentUser.rating.remove(oldRating)
        }
        
        currentUser.rating.insert(newRating)
        
        saveInFireBase(currentUser: currentUser, title: "Отлично!", message: "Вы правильно ответили на этот вопрос!")
    }
    
    private func addSnoozedTime() {
        let today = Date()
        let dateComponents = DateComponents(calendar: Calendar.current,
                                            timeZone: nil,
                                            era: nil,
                                            year: nil,
                                            month: nil,
                                            day: 1,
                                            hour: nil,
                                            minute: nil,
                                            second: nil,
                                            nanosecond: nil,
                                            weekday: nil,
                                            weekdayOrdinal: nil,
                                            quarter: nil,
                                            weekOfMonth: nil,
                                            weekOfYear: nil,
                                            yearForWeekOfYear: nil
                                            )
        
        guard
            var currentUser = (UIApplication.shared.delegate as! AppDelegate).appManager.getCurrentUser(),
            let tomorrow = Calendar.current.date(byAdding: dateComponents, to: today) else {
            return
        }
        
        activityIndicator.start()
        
        let questionID = questionsInsideArray[sequence].id

        self.snozzedTime = tomorrow
        
        var newDetails: Set<PassedQuestions.Details> = [PassedQuestions.Details(questionID: questionID, passed: false, snoozedTill: tomorrow)]
        var oldRating: PassedQuestions?
        var newRating = PassedQuestions(competenceID: competenceId, earnedPoints: 0, totalPoints: totalPoints, details: newDetails)
        
        let userRatings = currentUser.rating
        
        for rating in userRatings {
            if rating.competenceID == competenceId {
                oldRating = rating
                newDetails = getUpdatedDetails(currentDetails: rating.details, passed: false, snoozedTime: tomorrow)
                newRating = PassedQuestions(competenceID: competenceId, earnedPoints: rating.earnedPoints, totalPoints: totalPoints, details: newDetails)
                break
            }
        }
        
        if let oldRating = oldRating {
            currentUser.rating.remove(oldRating)
        }
        
        currentUser.rating.insert(newRating)
        
        saveInFireBase(currentUser: currentUser, title: "Неправильно!", message: "Увы, Вы не правильно ответили. Повторно ответить на данный вопрос Вы сможете только через 24 часа.")
    }
    
    private func getUpdatedDetails(currentDetails: Set<PassedQuestions.Details>, passed: Bool, snoozedTime: Date?) -> Set<PassedQuestions.Details> {
        var returningValue = currentDetails
        let questionID = questionsInsideArray[sequence].id
        
        let updatedDetail = PassedQuestions.Details(questionID: questionID, passed: passed, snoozedTill: snoozedTime)
        var oldDetail: PassedQuestions.Details?
        
        for question in currentDetails {
            if question.questionID == questionID {
                oldDetail = question
                break
            }
        }
        
        if let oldDetail = oldDetail {
            returningValue.remove(oldDetail)
        }
        
        returningValue.insert(updatedDetail)
        
        return returningValue
    }
    
    private func saveInFireBase(currentUser: User, title: String, message: String) {
        FirebaseController.shared.getDataController().saveData(currentUser, with: currentUser.id, in: DBTables.users) {
            (result: Result<User>) in
            
            self.activityIndicator.stop()

            if let user = result.value {
                (UIApplication.shared.delegate as! AppDelegate).appManager.loggedIn(as: user)
                self.tableView.reloadData()
            }
            
            let alertDialog = AlertDialog(title: title, message: message)
            alertDialog.showAlert(in: self, completion: nil)
        }
    }
}


extension AnswerQuestionsTableViewController: SubmitedAnswersProcessingProtocol {
    func preceedWithSubmittedAnswers() {
        if usersAnswers == correctAnswers {
            updateUserWithProgress()
        } else {
            addSnoozedTime()
        }
    }
}
