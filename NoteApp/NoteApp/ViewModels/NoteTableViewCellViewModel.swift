//
//  NoteTableViewCellViewModel.swift
//  NoteApp
//
//  Created by Balsa Komnenovic on 13.3.23..
//

import Foundation

class NoteTableViewCellViewModel {
    let title: String
    let date: String
    
    //MARK: - Init
    init(title: String, date: String) {
        self.title = title
        self.date = date
    }
}
