//
//  LibraryView.swift
//  MiniCalm
//
//  Created by Varun Sharma on 17/09/26.
//

import SwiftUI


struct LibraryView: View {
    @State var viewModel = LibraryViewModel()
    var body: some View {
        
        VStack {
            NavigationStack {
                
                
                List(viewModel.sessions) { session in
                    ZStack {
                        //Text(String(session.title))
                        HStack(spacing: 12) {
                            
                            AsyncImage(url: session.artworkUrl) { image in
                                image.resizable().aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Color.gray.opacity(0.2)
                                    .overlay(Image(systemName: "waveform").foregroundColor(.secondary))
                            }
                            .frame(width: 56, height: 56)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(session.title)
                                        .font(.headline)
                                    if session.isPremium {
                                        Image(systemName: "crown.fill")
                                            .font(.caption)
                                            .foregroundColor(.orange)
                                    }
                                }
                                
                                Text("\(session.teacher) • \(session.formattedDuration)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        
        .task {
            await viewModel.fetchRequest()
        }
    }
}

#Preview {
    LibraryView(viewModel: LibraryViewModel())
}


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
