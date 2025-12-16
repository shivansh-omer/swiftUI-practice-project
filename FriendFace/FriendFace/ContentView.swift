//
//  ContentView.swift
//  FriendFace
//
//  Created by Shivansh omer on 30/04/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UserViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.users) { user in
                NavigationLink(destination: DetailView(user: user)) {
                    HStack {
                        Text(user.name)
                        Spacer()
                        Circle()
                            .fill(user.isActive ? .green : .gray)
                            .frame(width: 10, height: 10)
                    }
                }
            }
            .navigationTitle("FriendFace")
            .onAppear {
                viewModel.loadData()
            }
        }
    }
}

struct DetailView: View {
    let user: User

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Age: \(user.age)")
                Text("Company: \(user.company)")
                Text("Email: \(user.email)")
                Text("Address: \(user.address)")
                Text("About: \(user.about)")
                Text("Tags: \(user.tags.joined(separator: ", "))")

                Text("Friends:")
                    .font(.headline)
                ForEach(user.friends) { friend in
                    Text(friend.name)
                }
            }
            .padding()
        }
        .navigationTitle(user.name)
    }
}

#Preview {
    ContentView()
}
