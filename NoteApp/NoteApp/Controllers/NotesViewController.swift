//
//  ViewController.swift
//  NoteApp
//
//  Created by Balsa Komnenovic on 13.3.23..
//

import UIKit

class NotesViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.identifier)
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var notes = [Note]()
    private let viewModel = NoteViewModel()
    
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAllNotes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getAllNotes()
    }
    
    override func viewDidLoad() {
        title = "Notes"
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        setupTableView()
        viewModel.getAllNotes()
        viewModel.delegate = self
    }
    
    //MARK: - Private
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: - @objc private
    @objc private func didTapAdd() {
        let vc = AddNoteViewController(note: nil)
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - NoteViewModelDelegate
extension NotesViewController: NoteViewModelDelegate {
    func didLoadNotes() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func didTapNote(didSelectNote note: Note) {
        let vc = AddNoteViewController(note: note)
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
