//
//  APICallerVanilla.swift
//  NoteApp
//
//  Created by Balsa Komnenovic on 14.3.23..
//

import Foundation

enum ServiceError: Error {
    case failedToCreateRequest
    case failedToGetData
}

class APICallerVanilla {
    /// Shared instance
    static let shared = APICallerVanilla()
    
    //MARK: - Public
    public func fetchAllNotes(completion: @escaping (Result<[Note], Error>) -> Void) {
        guard let url = URL(string: "http://192.168.1.7:8081/fetch") else {
            completion(.failure(ServiceError.failedToGetData))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? ServiceError.failedToGetData))
                return
            }
            
            do {
                let notes = try JSONDecoder().decode([Note].self, from: data)
                completion(.success(notes))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    public func addNote(date: String, title: String, note: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://192.168.1.7:8081/create") else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "title": title,
            "date": date,
            "note": note
        ]
        
        let task = URLSession.shared.dataTask(with: request) { _, _, error in
            if error != nil {
                completion(false)
                return
            } else {
                print("Successfully added note!")
                completion(true)
            }
        }
        
        task.resume()
    }
    
    public func updateNote(date: String, title: String, note: String, id: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://192.168.1.7:8081/update") else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "id": id,
            "title": title,
            "date": date,
            "note": note
        ]
        
        let task = URLSession.shared.dataTask(with: request) { _, _, error in
            if error != nil {
                completion(false)
                return
            } else {
                print("Successfully updated note!")
                completion(true)
            }
        }
        
        task.resume()
        //        AF.request("http://192.168.1.7:8081/update", method: .post, encoding: URLEncoding.httpBody, headers: [
        //            "id": id,
        //            "title": title,
        //            "date": date,
        //            "note": note
        //        ]).responseJSON { [weak self] response in
        //            print(response)
        //        }
    }
    
    public func deleteNote(id: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://192.168.1.7:8081/delete") else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["id": id]
        
        let task = URLSession.shared.dataTask(with: request) { _, _, error in
            if error != nil {
                completion(false)
                return
            } else {
                print("Successfully deleted note!")
                completion(true)
            }
        }
        
        task.resume()
        //        AF.request("http://192.168.1.7:8081/delete", method: .post, encoding: URLEncoding.httpBody, headers: ["id": id]).responseJSON { [weak self] response in
        //            print(response)
        //        }
    }
}
