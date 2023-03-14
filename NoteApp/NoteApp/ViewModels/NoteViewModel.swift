//
//  NoteViewModel.swift
//  NoteApp
//
//  Created by Balsa Komnenovic on 13.3.23..
//

import UIKit

protocol NoteViewModelDelegate: AnyObject {
    func didLoadNotes()
    func didTapNote(didSelectNote note: Note)
}

class NoteViewModel: NSObject {
    public var notes: [Note] = []
    public weak var delegate: NoteViewModelDelegate?
    
    //MARK: - Public
    public func getAllNotes() {
        APICallerVanilla.shared.fetchAllNotes { [weak self] result in
            switch result {
            case .success(let notes):
                self?.notes = notes
                self?.delegate?.didLoadNotes()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - TableView
extension NoteViewModel: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = notes[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier, for: indexPath) as? NoteTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = viewModel.title
//        cell.configure(with: NoteTableViewCellViewModel(title: viewModel.title, date: viewModel.date))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didTapNote(didSelectNote: notes[indexPath.row])
//        navigationController?.navigationBar.prefersLargeTitles = false
//        navigationController?.navigationItem.largeTitleDisplayMode = .never
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
