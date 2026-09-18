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
                    
                    NavigationLink {
                        AudioPlayerViewControllerRepresentable(session: session)
                            .navigationTitle(session.title)
                            .navigationBarTitleDisplayMode(.inline)
                    }
                    label : {
                        ZStack {
                            
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
          
        }
        
        .preferredColorScheme(.dark)
        .task {
            await viewModel.fetchRequest()
        }
    }
}

#Preview {
    LibraryView(viewModel: LibraryViewModel())
}

