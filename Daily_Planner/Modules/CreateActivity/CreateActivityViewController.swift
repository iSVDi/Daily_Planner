//
//  CreateActivityViewController.swift
//  Daily_Planner
//
//  Created by Daniil on 17.01.2024.
//

import UIKit

protocol CreateActivityDelegate: NSObjectProtocol {
    func showAlert(title: String, message: String)
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
        navigationItem.title = "Create Activity"
        titleTextField.placeholder = "Title"
        descriptionTextView.delegate = self
        dateStartLabel.text = "Date start"
        dateFinishLabel.text = "Date finish"
        descriptionTextView.text = "Placeholder"
        descriptionTextView.textColor = descriptionPlaceholderColor
        descriptionTextView.delegate = self

        [titleTextField, descriptionTextView].forEach {
            $0.backgroundColor = .appSystemGray
            $0.layer.cornerRadius = 10
        }

        let currentDate = Date()
        [dateStartPicker, dateFinishPicker].forEach {
            $0.datePickerMode = .dateAndTime
            $0.date = currentDate
        }

        let rightBarButtonItem = UIBarButtonItem(title: "Create",
                                                 style: .done,
                                                 target: self,
                                                 action: #selector(rightBarButtonHandler))
        navigationItem.setRightBarButton(rightBarButtonItem, animated: false)
        navigationItem.rightBarButtonItem?.isEnabled = false
        titleTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
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

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // TODO: localize
        let ok = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }

}
