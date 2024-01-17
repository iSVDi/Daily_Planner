//
//  CreateActivityViewController.swift
//  Daily_Planner
//
//  Created by Daniil on 17.01.2024.
//

import UIKit

class CreateActivityViewController: UIViewController {

    private let titleTextField = UITextField()
    private let descriptionTextView = UITextView()
    private let datePicker = UIDatePicker()

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
        [titleTextField, descriptionTextView, datePicker].forEach {
            stack.addArrangedSubview($0)
        }

        stack.edgesToSuperview(excluding: .bottom, insets: .horizontal(16), usingSafeArea: true)
        titleTextField.horizontalToSuperview()
        descriptionTextView.horizontalToSuperview()
        titleTextField.heightToSuperview(multiplier: 0.15)
        descriptionTextView.heightToSuperview(multiplier: 0.7)
        datePicker.rightToSuperview()
    }

    // TODO: localize
    private func setupViews() {
        navigationItem.title = "Create Activity"
        titleTextField.placeholder = "Title"
        descriptionTextView.delegate = self
        [titleTextField, descriptionTextView].forEach {
            $0.backgroundColor = .appSystemGray
            $0.layer.cornerRadius = 10
        }
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()

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

        let isEnable = !title.isEmpty && !descriptionTextView.text.isEmpty
        navigationItem.rightBarButtonItem?.isEnabled = isEnable

    }

    @objc
    private func textFieldDidChange() {
        updateNavigationBarIfNeed()
    }

    @objc
    private func rightBarButtonHandler() {
        print("create activity")
    }

}

// MARK: - UITextViewDelegate

extension CreateActivityViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        updateNavigationBarIfNeed()
    }

}
