//
//  ContentView.swift
//  teste 3
//
//  Created by AMANDA CAROLINE DA SILVA RODRIGUES on 03/02/25.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @StateObject private var imageViewModel = ImageViewModel()
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    var body: some View {
        NavigationView{
            VStack {
                
                List(imageViewModel.images, id:\.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .padding()
                } .onAppear {
                    imageViewModel.loadImage()
                }
                
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    Text("Escolher imagem")
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let selectedItem {
                            let data = try? await selectedItem.loadTransferable(type: Data.self)
                            if let data, let uiImage = UIImage(data: data) {
                                selectedImage = uiImage
                                imageViewModel.saveImage(image: uiImage)
                                imageViewModel.loadImage()
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
