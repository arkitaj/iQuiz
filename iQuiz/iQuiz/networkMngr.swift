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
                self.saveQuizzesLocally(quizzes)

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
    private func getLocalFileURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documents.appendingPathComponent("quizzes.json")
    }
    
    
    func saveQuizzesLocally(_ quizzes: [Quiz]) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(quizzes)
            let url = getLocalFileURL()
            try data.write(to: url)
            print("Saved quizzes locally")
        } catch {
            print("Failed to save locally:", error)
        }
    }
    
    func loadLocalQuizzes() -> [Quiz]? {
        let url = getLocalFileURL()
        do {
            let data = try Data(contentsOf: url)
            let quizzes = try JSONDecoder().decode([Quiz].self, from: data)
            print("Loaded quizzes from local storage")
            return quizzes
        } catch {
            print("No local quizzes found")
            return nil
        }
    }
}
