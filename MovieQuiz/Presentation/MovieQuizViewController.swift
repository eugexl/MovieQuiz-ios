//
// Sprint 06 Branch
//

import UIKit

// MARK: - MovieQuizViewController Class
///
final class MovieQuizViewController: UIViewController{
    
    // MARK: - Properties
    
    // Outlets
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var questionIndexLabel: UILabel!
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    /// Фабрика вопросов
    private var questionFactory: QuestionFactoryProtocol?
    /// Текущий вопрос
    private var currentQuestion: QuizQuestion?
    /// Количество вопросов в игре
    private let questionsAmount: Int = 10
    /// Индекс текущего вопроса
    private var currentQuestionIndex = 0
    /// Количество правильных ответов
    private var correctAnswers = 0
    /// Сервис подсчёта, обработки результатов квиза
    private let statisticService: StatisticService = StatisticServiceImplementation()
    
    /// Фабрика уведомлений
    internal var alertPresenter: AlertPresenterProtocol?
    
    // Окрашиваем статусную панель в светлые тона
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        someMakeup()
        
        // Обеспечение зависимостей
        questionFactory = QuestionFactory(delegate: self)
        alertPresenter = AlertPresenter(delegate: self)
        
        // Запускаем Activity indicator
        showLoadingIndicator(is: true)
    }
    
    // MARK: - IBActions
    
    /// Метод вызываемый по нажатию кнопки Нет
    @IBAction private func noButtonClicked(_ sender: UIButton){
        // Вызываем реакцию приложения на отрицательный ответ пользователя
        toggleButtons(to: false)
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
    }
    
    /// Метод вызываемый по нажатию кнопки Да
    @IBAction private func yesButtonClicked(_ sender: UIButton){
        // Вызываем реакцию приложения на утвердительных ответ пользователя
        toggleButtons(to: false)
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
    }
    
    // MARK: - Private functions
    
    /// Подготовка вопроса к визуализации
    /// - Parameters:
    ///     - question: QuizQuestion-структура
    /// - Returns: Возвращает структуру "QuizStepViewModel" для отображения вопроса в представлении
    private func convert(question: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: question.image) ?? UIImage(),
            question: question.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    /// Смена декораций представления/view
    ///  - Parameters:
    ///     - quizStep: QuizStepViewModel-структура, содержащая необходимые элементы для обновления представления
    ///
    private func show(quizStep model: QuizStepViewModel){
        
        // Убираем окраску рамки изображения
        mainImageView.layer.borderColor = UIColor.clear.cgColor
        // Адаптируем интерфейс под новый вопрос
        questionIndexLabel.text = model.questionNumber
        mainImageView.image = model.image
        questionLabel.text = model.question
        // Включаем кнопки
        toggleButtons(to: true)
    }
    
    /// Метод включающий/выключающий кнопки ответов
    ///  - Parameters:
    ///     - to: Состояние в которое переводится свойство кнопок isEnabled, true - включаем кнопки, false - отключаем
    private func toggleButtons(to state: Bool){
        noButton.isEnabled = state
        yesButton.isEnabled = state
    }
   
    /// Реагируем на ответ пользователя (нажатие кнопки ответа) - окрашиваем рамку картинки, переходим к следующему вопросу
    /// - Parameters:
    ///     - isCorrect: индикатор верности ответа
    private func showAnswerResult(isCorrect: Bool){
        
        // Окрашиваем рамку картинки вопроса в соответствии с правильностью ответа
        mainImageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        // Если ответ верный инкриментируем счётчик верных ответов
        if isCorrect {
            correctAnswers += 1
        }
        
        // Пауза перед следующим вопросом
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){ [weak self] in
            self?.showNextQuestionOrResults()
        }
    }
    
    /// Отображение следующего вопроса или результатов
    private func showNextQuestionOrResults(){
       
        // Если предыдущий вопрос был последним подводим итог текущей игры
        if currentQuestionIndex == questionsAmount - 1 {
            
            let totalQuestions = currentQuestionIndex + 1
            statisticService.store(correct: correctAnswers, total: totalQuestions)
            
            // Подготавливаем уведомление
            let bestGame = statisticService.bestGame
            let text = """
                Ваш результат: \(correctAnswers)/\(totalQuestions)
                Количество сыгранных квизов: \(statisticService.gamesCount)
                Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
                Средняя точность: \(String(format: "%.2f", statisticService.accuracy))%
            """
            let alertModel = AlertModel(title: "Этот раунд окончен!", message: text, buttonText: "Сыграть ещё раз", completion: startNewQuiz)
            
            // Отображаем уведомление
            alertPresenter?.alert(with: alertModel)
            
        // Иначе переходим к следующему вопросу
        } else {
            // Инкриментируем счётчик текущего вопроса
            currentQuestionIndex += 1
            // Посылаем запрос на вопрос на фабрику вопросов
            questionFactory?.requestNextQuestion()
        }
    }
    
    /// Настраиваем параметры представления
    private func someMakeup(){
        
        // У меня Xcode (14.3) не отображает установленные шрифты в списке шрифтов. Перепробовал всё, что рекомендовалось, поэтому ...
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionIndexLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        mainImageView.layer.masksToBounds = true
        
        // В соответствии с Figma-моделью
        mainImageView.layer.borderWidth = 8
        mainImageView.layer.cornerRadius = 20
        
        activityIndicator.hidesWhenStopped = true
    }
    
    /// Прячем/отображаем индикатор активности
    internal func showLoadingIndicator(is displayed: Bool){
        if displayed {
            activityIndicator.startAnimating()
        } else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    /// Отображаем уведомление о возникновении ошибки на уровне сети
    private func showNetworkError(message: String){
        showLoadingIndicator(is: false)
        
        let messageText = message.isEmpty ? "При загрузке данных возникла ошибка" : message
        
        let alertModel = AlertModel(title: "Ошибка", message: messageText, buttonText: "Попробовать ещё раз" ) { [weak self] _ in
            
            self?.questionFactory?.loadData()
        }
        alertPresenter?.alert(with: alertModel)
    }
}

// MARK: - Extensions

// MARK: - QuestionFactoryDelegate
/// Расширение для соответствия делегату фабрики вопросов
extension MovieQuizViewController: QuestionFactoryDelegate {
    
    /// Обработка Квиз-вопроса, полученного от фабрики вопросов
    internal func didReceiveNextQuestion(question: QuizQuestion?){
       
        guard let question  = question else { return }
        
        currentQuestion = question
        
        let viewModel = convert(question: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quizStep: viewModel)
        }
    }
    func didLoadDataFromServer(){
        showLoadingIndicator(is: false)
        questionFactory?.requestNextQuestion()
    }
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
}

// MARK: - AlertPresenterDelegate
/// Расширение для соответствия алерт-делегату
extension MovieQuizViewController: AlertPresenterDelegate {
    
    /// Функция для инициализации квиз-раунда
    internal func startNewQuiz( _ : UIAlertAction){
        
        self.currentQuestionIndex = 0
        self.correctAnswers = 0
        self.questionFactory?.requestNextQuestion()
    }
}
