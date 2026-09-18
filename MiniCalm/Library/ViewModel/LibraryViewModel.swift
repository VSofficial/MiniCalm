//
//  LibraryViewModel.swift
//  MiniCalm
//
//  Created by Varun Sharma on 17/09/26.
//

import SwiftUI



@Observable
@MainActor
class LibraryViewModel {
    static let shared = LibraryViewModel()
    var sessions: [Session] = []
    var isLoading = false
    var errorMessage: String?
    var items = [1,2,3,4]
    
    private let contentURLString = "https://gist.githubusercontent.com/Manojsuthar2000/441d8e745e124afe601fb85fb1c49a31/raw/sessions.json"
    
    func fetchRequest() async {
        guard let url = URL(string: contentURLString) else {
            errorMessage = "Invalid URL"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(SessionResponse.self, from:data)
            self.sessions = response.sessions
        } catch {
            errorMessage = "Failed to load data: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
