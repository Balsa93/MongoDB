//
//  AddNoteViewController.swift
//  NoteApp
//
//  Created by Balsa Komnenovic on 13.3.23..
//

import UIKit

class AddNoteViewController: UIViewController {
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .sentences
        textField.placeholder = "Title..."
        textField.textAlignment = .center
        textField.textColor = .label
        textField.backgroundColor = .secondaryLabel
        textField.layer.cornerRadius = 8
        textField.font = .systemFont(ofSize: 16, weight: .medium)
        return textField
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.autocapitalizationType = .sentences
        textView.autocorrectionType = .no
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Write Your Note Here..."
        textView.textAlignment = .left
        textView.textColor = .secondaryLabel
        textView.backgroundColor = .tertiaryLabel
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.isEditable = true
        textView.layer.cornerRadius = 8
        return textView
    }()
    
    public var note: Note?
    
    //MARK: - Init
    init(note: Note?) {
        self.note = note
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add a New Note"
        view.backgroundColor = .systemBackground
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(textView)
        view.addSubview(textField)
        view.addSubview(saveButton)
        addConstraints()
        
        if let safeNote = note {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDelete))
            navigationItem.rightBarButtonItem?.tintColor = .red
            textView.text = safeNote.note
            textField.text = safeNote.title
        }
    }
    
    //MARK: - @objc private
    @objc private func didTapDelete() {
        guard let note = note else { return }
        let alert = UIAlertController(title: "Delete", message: "Do you wish to delete your Note.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            //            APICallerAlamofire.shared.deleteNote(id: self?.note!._id ?? "")
            APICallerVanilla.shared.deleteNote(id: note._id) { [weak self] success in
                DispatchQueue.main.async {
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            }
        })
        present(alert, animated: true)
    }
    
    @objc private func saveButtonTapped() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.string(from: Date())
        guard let title = textField.text, !title.isEmpty, let body = textView.text, !body.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Please enter all information for your Note.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
            return
        }
        
        if note != nil {
//            APICallerAlamofire.shared.updateNote(date: date, title: title, note: body, id: note!._id)
            APICallerVanilla.shared.updateNote(date: date, title: title, note: body, id: note!._id) { [weak self] success in
                if success {
                    DispatchQueue.main.async {
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: "Something went wrong while updating Note.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                        self?.present(alert, animated: true)
                    }
                }
            }
        } else {
            //            APICallerAlamofire.shared.addNote(date: date, title: title, note: body)
            APICallerVanilla.shared.addNote(date: date, title: title, note: body) { [weak self] success in
                if success {
                    DispatchQueue.main.async {
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: "Something went wrong while saving Note.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                        self?.present(alert, animated: true)
                    }
                }
            }
        }
    }
    
    //MARK: - Private
    private func addConstraints() {
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            textField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            textField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            textField.heightAnchor.constraint(equalToConstant: 48),
            
            textView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10),
            textView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            textView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            
            saveButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 10),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 52),
            saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
