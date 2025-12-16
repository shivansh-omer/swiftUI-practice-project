//
//  ContentView.swift
//  NameSnap
//
//  Created by Shivansh omer on 18/05/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \NamedPhoto.name) private var photos: [NamedPhoto]
    
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var showingNamePrompt = false
    @State private var tempPhotoData: Data?
    @State private var newPhotoName = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(photos) { photo in
                    NavigationLink(destination: PhotoDetailView(photo: photo)) {
                        HStack {
                            if let image = UIImage(data: photo.photoData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                            } else {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 50, height: 50)
                            }
                            
                            Text(photo.name)
                                .padding(.leading, 10)
                            
                            Spacer()
                        }
                        .padding(.vertical, 5)
                    }
                }
                .onDelete(perform: deletePhotos)
            }
            .navigationTitle("Photo Namer")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    PhotosPicker(selection: $photosPickerItem, matching: .images) {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("Name this photo", isPresented: $showingNamePrompt) {
                TextField("Name", text: $newPhotoName)
                Button("Save") {
                    savePhoto()
                }
                Button("Cancel", role: .cancel) {
                    tempPhotoData = nil
                    newPhotoName = ""
                }
            } message: {
                Text("Enter a name to help you remember this person or place.")
            }
        }
        .onChange(of: photosPickerItem) {
            Task {
                if let photosPickerItem,
                   let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                    // Got the image data, store it temporarily and ask for a name
                    tempPhotoData = data
                    showingNamePrompt = true
                }
                self.photosPickerItem = nil
            }
        }
    }
    
    private func savePhoto() {
        guard let photoData = tempPhotoData, !newPhotoName.isEmpty else { return }
        
        let namedPhoto = NamedPhoto(name: newPhotoName, photoData: photoData)
        modelContext.insert(namedPhoto)
        
        // Reset temporary values
        tempPhotoData = nil
        newPhotoName = ""
    }
    
    private func deletePhotos(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(photos[index])
        }
    }
}

#Preview {
    ContentView()
}
