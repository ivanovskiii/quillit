//
//  Notification.swift
//  Quillit
//
//  Created by Gorjan Ivanovski on 30.11.23.
//

import Foundation

struct Notification: Identifiable, Codable {
    var id: String
    let type: NotificationType
    let user: User

    private enum CodingKeys: String, CodingKey {
        case id, type, user
    }

    init(id: String, type: NotificationType, user: User) {
        self.id = id
        self.type = type
        self.user = user
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.type = try container.decode(NotificationType.self, forKey: .type)
        self.user = try container.decode(User.self, forKey: .user)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(user, forKey: .user)
    }
}


