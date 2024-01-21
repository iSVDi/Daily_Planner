//
//  CreateActivityViewController.swift
//  Daily_Planner
//
//  Created by Daniil on 17.01.2024.
//

import UIKit

enum Mode {
    case create
    case details
}

protocol CreateActivityDelegate: NSObjectProtocol {
    var mode: Mode { get }
    func showAlert(title: String, message: String)
    func closeController()
}

class CreateActivityViewController: UIViewController {

    private let titleTextField = UITextField()
    private let dateStartLabel = UILabel()
    private let dateFinishLabel = UILabel()
    private let descriptionTextView = UITextView()
    private let dateStartPicker = UIDatePicker()
    private let dateFinishPicker = UIDatePicker()
    private let descriptionPlaceholderColor: UIColor = .appLightGray
    private lazy var presenter = CreateActivityPresenter(self)
    private let activityMode: Mode
    private let createHandler: (() -> Void)?
    private let activity: Activity?

    class func getController(for mode: Mode, _ completionHandler: @escaping (() -> Void)) -> UIViewController {
        return CreateActivityViewController(mode: mode, completionHandler)
    }

    class func getController(for mode: Mode, _ activity: Activity) -> UIViewController {
        return CreateActivityViewController(mode: mode, activity)
    }

    private init(mode: Mode, _ completionHandler: @escaping (() -> Void)) {
        self.createHandler = completionHandler
        self.activityMode = mode
        self.activity = nil
        super.init(nibName: nil, bundle: nil)
    }

    private init(mode: Mode, _ activity: Activity) {
        self.activity = activity
        self.activityMode = mode
        self.createHandler = nil
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        applyDefaultSettings()
        setupLayout()
        setupViews()
    }

    private func setupLayout() {
        let stack = UIStackView()
        stack.alignment = .center
        stack.axis = .vertical
        stack.spacing = 10
        view.addSubview(stack)

        let dateStartStack = getDatePickerStack(label: dateStartLabel, datePicker: dateStartPicker)
        let dateFinishStack = getDatePickerStack(label: dateFinishLabel, datePicker: dateFinishPicker)

        [titleTextField, descriptionTextView, dateStartStack, dateFinishStack].forEach {
            stack.addArrangedSubview($0)
        }

        stack.edgesToSuperview(excluding: .bottom, insets: .horizontal(16), usingSafeArea: true)
        titleTextField.horizontalToSuperview()
        descriptionTextView.horizontalToSuperview()
        titleTextField.heightToSuperview(multiplier: 0.15)
        descriptionTextView.heightToSuperview(multiplier: 0.7)
    }

    // TODO: localize
    private func setupViews() {
        [titleTextField, descriptionTextView].forEach {
            $0.backgroundColor = .appSystemGray
            $0.layer.cornerRadius = 10
        }

        dateStartLabel.text = "Date start"
        dateFinishLabel.text = "Date finish"

        guard mode == .create else {
            setupViewsForDetails()
            return
        }

        let currentDate = Date()
        [dateStartPicker, dateFinishPicker].forEach {
            $0.datePickerMode = .dateAndTime
            $0.date = currentDate
        }

        navigationItem.title = "Create Activity"
        titleTextField.placeholder = "Title"
        descriptionTextView.delegate = self
        descriptionTextView.text = "Placeholder"
        descriptionTextView.textColor = descriptionPlaceholderColor
        descriptionTextView.delegate = self

        let rightBarButtonItem = UIBarButtonItem(title: "Create",
                                                 style: .done,
                                                 target: self,
                                                 action: #selector(rightBarButtonHandler))
        navigationItem.setRightBarButton(rightBarButtonItem, animated: false)
        navigationItem.rightBarButtonItem?.isEnabled = false
        titleTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    private func setupViewsForDetails() {
        if let activity = activity {
            dateStartPicker.date = Date(timeIntervalSince1970: activity.dateStart)
            dateFinishPicker.date = Date(timeIntervalSince1970: activity.dateFinish)
            titleTextField.text = activity.title
            descriptionTextView.text = activity.details
        }

        [titleTextField, descriptionTextView, dateStartPicker, dateFinishPicker].forEach {
            $0.isUserInteractionEnabled = false
        }
        navigationItem.title = "Details"
    }

    private func updateNavigationBarIfNeed() {
        guard let title = titleTextField.text else {
            return
        }

        let isEnable = !title.isEmpty && !descriptionTextView.text.isEmpty && descriptionTextView.textColor != descriptionPlaceholderColor
        navigationItem.rightBarButtonItem?.isEnabled = isEnable

    }

    private func getDatePickerStack(label: UILabel, datePicker: UIDatePicker) -> UIView {
        let stack = UIStackView()
        [label, datePicker].forEach {
            stack.addArrangedSubview($0)
        }
        return stack
    }

    @objc
    private func textFieldDidChange() {
        updateNavigationBarIfNeed()
    }

    @objc
    private func rightBarButtonHandler() {
        guard let title = titleTextField.text,
              let details = descriptionTextView.text,
              presenter.isDatesCorrect(dateStart: dateStartPicker.date, dateFinish: dateFinishPicker.date) else {
            return
        }

        let activity = Activity()
        activity.title = title
        activity.details = details
        activity.dateStart = dateStartPicker.date.timeIntervalSince1970
        activity.dateFinish = dateFinishPicker.date.timeIntervalSince1970

        presenter.createActivity(activity: activity)
    }

}

// MARK: - UITextViewDelegate

extension CreateActivityViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        updateNavigationBarIfNeed()
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == descriptionPlaceholderColor {
                textView.text = nil
                textView.textColor = UIColor.black
            }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            // TODO: localize
               textView.text = "Placeholder"
            textView.textColor = descriptionPlaceholderColor
           }
    }

}

// MARK: - CreateActivityDelegate

extension CreateActivityViewController: CreateActivityDelegate {

    var mode: Mode {
        return activityMode
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // TODO: localize
        let ok = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }

    func closeController() {
        createHandler?()
        navigationController?.popViewController(animated: true)
    }

}
