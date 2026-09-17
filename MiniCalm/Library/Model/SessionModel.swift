//
//  SessionModel.swift
//  MiniCalm
//
//  Created by Varun Sharma on 17/09/26.
//


import Foundation

struct SessionResponse: Codable {
    let sessions: [Session]
}

struct Session: Identifiable, Codable {
    let id: String
    let title: String
    let teacher: String
    let durationSeconds: Int
    let artworkUrl: URL?
    let audioUrl: URL
    let isPremium: Bool

    enum CodingKeys: String, CodingKey {
        case id, title, teacher
        case durationSeconds = "duration_seconds"
        case artworkUrl = "artwork_url"
        case audioUrl = "audio_url"
        case isPremium = "is_premium"
    }

    
    var formattedDuration: String {
        let minutes = durationSeconds / 60
        return "\(minutes) min"
    }
}
