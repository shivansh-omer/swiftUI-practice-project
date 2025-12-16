//
//  UserViewModel.swift
//  FriendFace
//
//  Created by Shivansh omer on 30/04/25.
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var users: [User] = []

    func loadData() {
        guard users.isEmpty else { return }

        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601

                if let decoded = try? decoder.decode([User].self, from: data) {
                    DispatchQueue.main.async {
                        self.users = decoded
                    }
                }
            }
        }.resume()
    }
}
