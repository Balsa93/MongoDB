//
//  APICaller.swift
//  NoteApp
//
//  Created by Balsa Komnenovic on 13.3.23..
//

import Foundation
import Alamofire

protocol APICallerAlamofireDelegate: AnyObject {
    func updateArray(newArray: String)
}

class APICallerAlamofire {
    /// Shared instance
    static let shared = APICallerAlamofire()
    
    /// Delegate
    weak var delegate: APICallerAlamofireDelegate?
    
    //MARK: - Public
    public func fetchNotes() {
        AF.request("http://192.168.0.29:8081/fetch").response { [weak self] response in
            guard let data = response.data, let stringData = String(data: data, encoding: .utf8) else { return }
            self?.delegate?.updateArray(newArray: stringData)
        }
    }
    
    public func addNote(date: String, title: String, note: String) {
        AF.request("http://192.168.0.29:8081/create", method: .post, encoding: URLEncoding.httpBody, headers: [
            "title": title,
            "date": date,
            "note": note
        ]).responseJSON { [weak self] response in
            print(response)
        }
    }
    
    public func updateNote(date: String, title: String, note: String, id: String) {
        AF.request("http://192.168.0.29:8081/update", method: .post, encoding: URLEncoding.httpBody, headers: [
            "id": id,
            "title": title,
            "date": date,
            "note": note
        ]).responseJSON { [weak self] response in
            print(response)
        }
    }
    
    public func deleteNote(id: String) {
        AF.request("http://192.168.0.29:8081/delete", method: .post, encoding: URLEncoding.httpBody, headers: ["id": id]).responseJSON { [weak self] response in
            print(response)
        }
    }
}
