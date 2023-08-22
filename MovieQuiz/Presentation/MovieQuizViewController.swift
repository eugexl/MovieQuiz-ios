//
// Sprint 06 Branch
//

import UIKit

// MARK: - MovieQuizViewController Class Protocol
protocol MovieQuizViewControllerProtocol: AnyObject {
    
    func show(quizStep model: QuizStepViewModel)
    func show(alert model: AlertModel)
    func toggleButtons(to state: Bool)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func showLoadingIndicator(is state: Bool)
}

// MARK: - MovieQuizViewController Class
final class MovieQuizViewController: UIViewController {
    
    // MARK: - Properties
    
    // Outlets
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var questionIndexLabel: UILabel!
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    /// Презентер из MVP
    private var presenter: MovieQuizPresenterProtocol?
    /// Фабрика уведомлений
    private var alertPresenter: AlertPresenterProtocol?
    
    // Окрашиваем статусную панель в светлые тона
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настройка внешнего вида пользовательского интерфейса
        someMakeup()
        
        // Формирование зависимостей
        alertPresenter = AlertPresenter(delegate: self)
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    // MARK: - IBActions
    
    /// Метод вызываемый по нажатию кнопки Нет
    @IBAction private func noButtonClicked(_ sender: UIButton){
        // Вызываем реакцию приложения на отрицательный ответ пользователя
        presenter?.didAnswer(isYes: false)
    }
    
    /// Метод вызываемый по нажатию кнопки Да
    @IBAction private func yesButtonClicked(_ sender: UIButton){
        // Вызываем реакцию приложения на утвердительных ответ пользователя
        presenter?.didAnswer(isYes: true)
    }
    
    // MARK: - Private methods
    
    /// Настраиваем первоначальные параметры представления
    private func someMakeup(){
        
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
}

// MARK: - MovieQuizViewControllerProtocol Methods

extension MovieQuizViewController: MovieQuizViewControllerProtocol {
    
    /// Смена декораций представления/view
    ///  - Parameters:
    ///     - quizStep: QuizStepViewModel-структура, содержащая необходимые элементы для обновления представления
    ///
    func show(quizStep model: QuizStepViewModel){
        
        // Убираем окраску рамки изображения
        mainImageView.layer.borderColor = UIColor.clear.cgColor
        
        // Адаптируем интерфейс под новый вопрос
        questionIndexLabel.text = model.questionNumber
        mainImageView.image = model.image
        questionLabel.text = model.question
        
        // Включаем кнопки
        toggleButtons(to: true)
    }
    
    /// Отображение уведомления/алерта
    ///  - Parameters:
    ///     - alert: Параметры уведомления в формате AlertModel
    func show(alert model: AlertModel) {
        alertPresenter?.alert(with: model)
    }
    
    /// Метод включающий/выключающий кнопки ответов
    ///  - Parameters:
    ///     - to: Состояние в которое переводится свойство кнопок isEnabled, true - включаем кнопки, false - отключаем
    func toggleButtons(to state: Bool){
        noButton.isEnabled = state
        yesButton.isEnabled = state
    }
    
    /// Окрашиваем цвет рамки изображения в зависимости от верности ответа
    func highlightImageBorder(isCorrectAnswer: Bool) {
        mainImageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    /// Прячем/отображаем индикатор активности
   func showLoadingIndicator(is state: Bool){
        if state {
            activityIndicator.startAnimating()
        } else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
    }
}
