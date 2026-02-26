//
//  networkMngr.swift
//  iQuiz
//
//  Created by Arkita Jain on 2/26/26.
//


import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func fetchQuizzes(from urlString: String, completion: @escaping (Result<[Quiz], Error>) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else { return }
            
            do {
                let quizzes = try JSONDecoder().decode([Quiz].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(quizzes))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
        }.resume()
    }
}
