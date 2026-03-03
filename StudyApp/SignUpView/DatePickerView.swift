//
//  DatePickerView.swift
//  StudyApp
//
//  Created by Rajesh Mani on 23/04/25.
//

import SwiftUI

struct DatePickerView: View {
    @State private var fromDate = Date()
    @State private var toDate = Date()
    @State private var fromDateText: String = ""
    @State private var toDateText: String = ""

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 16) {
                CustomTextFieldWrapper(
                    text: $fromDateText,
                    title: "From Date",
                    placeholder: fromDate.formatted(date: .long, time: .omitted),
                    date: $fromDate
                )
                .frame(height: 60)

                CustomTextFieldWrapper(
                    text: $toDateText,
                    title: "To Date",
                    placeholder: toDate.formatted(date: .long, time: .omitted),
                    date: $toDate
                )
                .frame(height: 60)
            }
            .padding()

            Text("Selected From Date: \(fromDate.formatted(date: .long, time: .omitted))")
        }
        .padding()
        .onAppear {
            // Initialize text fields with formatted dates
            fromDateText = fromDate.formatted(date: .long, time: .omitted)
            toDateText = toDate.formatted(date: .long, time: .omitted)
        }
    }
}

#Preview {
    DatePickerView()
}

class CustomTextField: UIView {
    let titleLabel = UILabel()
    let textField = UITextField()
    private let underline = CALayer()

    // Add this property
    var customInputView: UIView? {
        didSet {
            textField.inputView = customInputView
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        // Title Label
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .gray
        titleLabel.text = "Title"
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Text Field
        textField.borderStyle = .none
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false

        // Constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 32),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
        ])

        // Underline
        underline.backgroundColor = UIColor.lightGray.cgColor
        layer.addSublayer(underline)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let underlineHeight: CGFloat = 1
        underline.frame = CGRect(
            x: 0,
            y: bounds.height - underlineHeight,
            width: bounds.width,
            height: underlineHeight
        )
    }
}

// Your existing CustomTextField class with the added customInputView property (as above)

struct CustomTextFieldWrapper: UIViewRepresentable {
    @Binding var text: String
    var title: String
    var placeholder: String
    @Binding var date: Date

    func makeUIView(context: Context) -> CustomTextField {
        let customField = CustomTextField()
        customField.titleLabel.text = title
        customField.textField.placeholder = placeholder
        customField.textField.delegate = context.coordinator

        // Create UIDatePicker
        let datePicker = UIDatePicker()

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.date = date
        datePicker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged(_:)), for: .valueChanged)

        // Assign datePicker as inputView
        customField.customInputView = datePicker

        // Add toolbar with Done button to dismiss picker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: context.coordinator, action: #selector(Coordinator.donePressed))
        toolbar.setItems([doneButton], animated: false)
        customField.textField.inputAccessoryView = toolbar

        return customField
    }

    func updateUIView(_ uiView: CustomTextField, context _: Context) {
        uiView.textField.text = text
        uiView.titleLabel.text = title
        uiView.textField.placeholder = placeholder

        if let datePicker = uiView.textField.inputView as? UIDatePicker {
            datePicker.date = date
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomTextFieldWrapper

        init(_ parent: CustomTextFieldWrapper) {
            self.parent = parent
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }

        @objc func dateChanged(_ sender: UIDatePicker) {
            parent.date = sender.date
            // Update the text field text with formatted date
            parent.text = sender.date.formatted(date: .long, time: .omitted)
        }

        @objc func donePressed() {
            // Dismiss keyboard / inputView
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

#Preview {
    @Previewable @State var previewDate = Date()
    CustomTextFieldWrapper(text: .constant(""), title: "Test", placeholder: "Placeholder", date: $previewDate)
}
