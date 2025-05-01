//
//  DatePickerView.swift
//  StackViewChallenge
//
//  Created by Rajesh Mani on 01/05/25.
//  Copyright © 2025 Rasmusson Software Consulting. All rights reserved.
//

//import UIKit
//
//
//
//class DateSelectionViewController: UIViewController {
//
//    private let fromTextField = UITextField()
//    private let toTextField = UITextField()
//    private let datePicker = UIDatePicker()
//    private let doneButton = UIButton(type: .system)
//    
//    private var isSelectingFromDate = false
//    private let calendar = Calendar.current
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupUI()
//        configureDefaultDates()
//    }
//
//    private func setupUI() {
//        // Configure TextFields
//        [fromTextField, toTextField].forEach {
//            $0.borderStyle = .roundedRect
//            $0.textAlignment = .center
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            $0.inputView = UIView() // Disable keyboard
//            view.addSubview($0)
//        }
//
//        fromTextField.placeholder = "From"
//        toTextField.placeholder = "To"
//        
//        // Add Tap Gesture
//        fromTextField.addTarget(self, action: #selector(fromTapped), for: .touchDown)
//        toTextField.addTarget(self, action: #selector(toTapped), for: .touchDown)
//
//        // Configure DatePicker
//        datePicker.datePickerMode = .date
//        datePicker.maximumDate = Date() // No future dates
//        datePicker.preferredDatePickerStyle = .wheels
//        datePicker.translatesAutoresizingMaskIntoConstraints = false
//        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
//        view.addSubview(datePicker)
//
//        // Configure Done Button
//        doneButton.setTitle("Done", for: .normal)
//        doneButton.translatesAutoresizingMaskIntoConstraints = false
//        doneButton.isEnabled = false
//        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
//        view.addSubview(doneButton)
//
//        // Layout
//        NSLayoutConstraint.activate([
//            fromTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            fromTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            fromTextField.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
//            fromTextField.heightAnchor.constraint(equalToConstant: 40),
//            
//            toTextField.topAnchor.constraint(equalTo: fromTextField.topAnchor),
//            toTextField.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
//            toTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            toTextField.heightAnchor.constraint(equalToConstant: 40),
//            
//            datePicker.topAnchor.constraint(equalTo: fromTextField.bottomAnchor, constant: 20),
//            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            
//            doneButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
//            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//        ])
//    }
//
//    private func configureDefaultDates() {
//        let now = Date()
//        let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!
//        let fromDefault = calendar.date(byAdding: .day, value: -30, to: yesterday)!
//
//        toTextField.text = formatDate(yesterday)
//        fromTextField.text = formatDate(fromDefault)
//    }
//
//    @objc private func fromTapped() {
//        isSelectingFromDate = true
//        let currentToDate = parseDate(toTextField.text)
//        let maxDate = calendar.date(byAdding: .year, value: 5, to: Date())!
//
//        if let currentFrom = parseDate(fromTextField.text) {
//            datePicker.setDate(currentFrom, animated: true)
//        }
//
//        datePicker.minimumDate = calendar.date(byAdding: .day, value: -365 * 5, to: Date())
//        datePicker.maximumDate = yesterday()
//    }
//
//    @objc private func toTapped() {
//        isSelectingFromDate = false
//
//        if let currentTo = parseDate(toTextField.text) {
//            datePicker.setDate(currentTo, animated: true)
//        }
//
//        if let fromDate = parseDate(fromTextField.text) {
//            datePicker.minimumDate = fromDate
//            datePicker.maximumDate = calendar.date(byAdding: .day, value: 365, to: fromDate)
//            datePicker.maximumDate = yesterday()
//        } else {
//            datePicker.minimumDate = calendar.date(byAdding: .year, value: -5, to: Date())
//            datePicker.maximumDate = yesterday()
//        }
//    }
//
//    @objc private func dateChanged() {
//        let selected = datePicker.date
//
//        if isSelectingFromDate {
//            if calendar.isDateInToday(selected) {
//                // Reset to yesterday and clear To field
//                datePicker.setDate(yesterday(), animated: true)
//                toTextField.text = ""
//                fromTextField.text = ""
//                doneButton.isEnabled = false
//                return
//            }
//
//            fromTextField.text = formatDate(selected)
//            validateDoneButton()
//        } else {
//            toTextField.text = formatDate(selected)
//            validateDoneButton()
//        }
//        sanitizeFromDate()
//    }
//
//    @objc private func doneTapped() {
//        guard let from = fromTextField.text, let to = toTextField.text else { return }
//
//        let alert = UIAlertController(title: "Dates Selected",
//                                      message: "From: \(from)\nTo: \(to)",
//                                      preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true)
//    }
//
//    private func validateDoneButton() {
//        let fromDate = parseDate(fromTextField.text)
//        let toDate = parseDate(toTextField.text)
//
//        if let from = fromDate, let to = toDate, from < to {
//            doneButton.isEnabled = true
//        } else {
//            doneButton.isEnabled = false
//        }
//    }
//
//    private func formatDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd MMM yyyy"
//        return formatter.string(from: date)
//    }
//
//    private func parseDate(_ string: String?) -> Date? {
//        guard let string = string else { return nil }
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd MMM yyyy"
//        return formatter.date(from: string)
//    }
//
//    private func yesterday() -> Date {
//        return calendar.date(byAdding: .day, value: -1, to: Date())!
//    }
//    
//    private func sanitizeFromDate() {
//        if let from = parseDate(fromTextField.text), calendar.isDateInToday(from) {
//            fromTextField.text = ""
//            toTextField.text = ""
//            doneButton.isEnabled = false
//            datePicker.setDate(yesterday(), animated: true)
//        }
//    }
//}


import UIKit

enum StatementType {
    case e1
    case e
}

class DateSelectionViewController: UIViewController {
    
    private let fromTextField = UITextField()
    private let toTextField = UITextField()
    private let datePicker = UIDatePicker()
    private let doneButton = UIButton(type: .system)
    
    private var activeField: UITextField?
    private var statementType: StatementType = .eAdvice
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupInitialDates()
        configureDatePicker()
    }
    
    private func setupUI() {
        fromTextField.placeholder = "From Date"
        toTextField.placeholder = "To Date"
        
        [fromTextField, toTextField].forEach {
            $0.borderStyle = .roundedRect
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.addTarget(self, action: #selector(textFieldTapped(_:)), for: .editingDidBegin)
        }
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        doneButton.setTitle("Done", for: .normal)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        doneButton.isEnabled = false
        
        view.addSubview(fromTextField)
        view.addSubview(toTextField)
        view.addSubview(datePicker)
        view.addSubview(doneButton)
        
        let stack = UIStackView(arrangedSubviews: [fromTextField, toTextField])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.heightAnchor.constraint(equalToConstant: 40),
            
            datePicker.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 20),
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            doneButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func setupInitialDates() {
        let calendar = Calendar.current
        let now = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!
        let fromDate = calendar.date(byAdding: .day, value: -30, to: yesterday)!
        
        toTextField.text = formatDate(yesterday)
        fromTextField.text = formatDate(fromDate)
    }

    private func configureDatePicker() {
        datePicker.maximumDate = Date()
        
        switch statementType {
        case .eStatement:
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            }
            datePicker.datePickerMode = .date
        case .eAdvice:
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            }
            datePicker.datePickerMode = .date
        }
    }

    @objc private func textFieldTapped(_ sender: UITextField) {
        activeField = sender
        if let text = sender.text, let date = parseDate(text) {
            datePicker.setDate(date, animated: true)
        }
        
        updateDatePickerRange()
    }
    
    private func updateDatePickerRange() {
        let now = Date()
        let calendar = Calendar.current
        let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!
        let fiveYearsAgo = calendar.date(byAdding: .year, value: -5, to: now)!
        
        switch activeField {
        case fromTextField:
            // From Date: 5 years ago to yesterday (no future)
            datePicker.minimumDate = fiveYearsAgo
            datePicker.maximumDate = yesterday

        case toTextField:
            if let fromDate = parseDate(fromTextField.text ?? "") {
                // To Date: fromDate to 12 months after fromDate, but not beyond yesterday
                let twelveMonthsAfterFromDate = calendar.date(byAdding: .month, value: 12, to: fromDate)!
                datePicker.minimumDate = fromDate
                datePicker.maximumDate = min(twelveMonthsAfterFromDate, yesterday)
            }
            else {
                // If no fromDate, restrict to last 5 years up to yesterday
                datePicker.minimumDate = fiveYearsAgo
                datePicker.maximumDate = yesterday
            }

        default:
            break
        }
    }

    @objc private func dateChanged(_ sender: UIDatePicker) {
        let selected = sender.date
        let calendar = Calendar.current
        
        if activeField == fromTextField {
            if calendar.isDateInToday(selected) {
                let yesterday = calendar.date(byAdding: .day, value: -1, to: selected)!
                datePicker.setDate(yesterday, animated: true)
                toTextField.text = ""
                doneButton.isEnabled = false
                return
            }
        }

        let formattedDate = formatDate(sender.date)
        activeField?.text = formattedDate
        
        validateForm()
    }
    
    private func validateForm() {
        guard let fromDateStr = fromTextField.text,
              let toDateStr = toTextField.text,
              let fromDate = parseDate(fromDateStr),
              let toDate = parseDate(toDateStr) else {
            doneButton.isEnabled = false
            return
        }
        
        let calendar = Calendar.current
        let maxToDate = calendar.date(byAdding: .day, value: 365, to: fromDate)!
        
        if toDate <= maxToDate {
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
        }
    }

    @objc private func doneButtonTapped() {
        print("From: \(fromTextField.text ?? "")")
        print("To: \(toTextField.text ?? "")")
        // Perform any further actions here
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = statementType == .eStatement ? "MMM yyyy" : "dd MMM yyyy"
        if #available(iOS 17.4, *) {
            datePicker.datePickerMode = statementType == .eStatement ? .yearAndMonth :  .date
        } else {
            // Fallback on earlier versions
        }

        return formatter.string(from: date)
    }
    
    private func parseDate(_ text: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.date(from: text)
    }
    
    private func yesterday() -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: -1, to: Date())!
    }

}
