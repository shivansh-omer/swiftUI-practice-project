//
//  DetailView.swift
//  NameSnap
//
//  Created by Shivansh omer on 18/05/25.
//

import SwiftUI

struct PhotoDetailView: View {
    let photo: NamedPhoto
    
    var body: some View {
        VStack {
            if let image = UIImage(data: photo.photoData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .navigationTitle(photo.name)
            } else {
                Text("Unable to load image")
            }
        }
        .padding()
    }
}

#Preview {
    let sampleData = UIImage(systemName: "photo")!.pngData()!
    let samplePhoto = NamedPhoto(name: "Sample", photoData: sampleData)
    PhotoDetailView(photo: samplePhoto)
}
