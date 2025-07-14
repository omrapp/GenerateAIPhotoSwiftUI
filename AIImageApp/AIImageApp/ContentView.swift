//
//  ContentView.swift
//  AIImageApp
//
//  Created by Omar Ayed on 14/07/2025.
//

import SwiftUI
import PhotosUI
import ImagePlayground


struct ContentView: View {
    
    
    @Environment(\.supportsImagePlayground) var supportImagePlayground
    
    @State private var pickImage: Image?
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var isShowingImagePlayground = false
    @State private var prompt = ""
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 16) {
            
            PhotosPicker(
              selection: $photosPickerItem,
              matching: .images) {
                  Button("Pick Image", systemImage: "") {
                      
                  }.customButtonStyle()
              }
            
            Spacer()
            
            (pickImage ?? Image(systemName: "person.circle.fill"))
                .resizable()
                .foregroundStyle(.tint)
                .aspectRatio(contentMode: .fit)
                .clipShape(.circle)
                .padding(20)
               
            
            Spacer()
            
            if supportImagePlayground {
               
                TextField("Enter AI description", text: $prompt)
                    .font(.title3.bold())
                    .padding()
                    .background(.quaternary, in:.rect(cornerRadius: 16, style: .continuous))
                
                Button("Generate AI Image", systemImage: "sparkles") {
                    isShowingImagePlayground = true
                }.customButtonStyle()
            }
  
        }
        .padding(20)
        .onChange(of: photosPickerItem) { _, _ in
                    Task {
                        if let photosPickerItem, let data = try? await photosPickerItem.loadTransferable(type: Data.self), let uiImage =  UIImage(data: data) {
                            pickImage = Image(uiImage: uiImage)
                        }
                    }
        }.imagePlaygroundSheet(isPresented: $isShowingImagePlayground, concept: prompt, onCompletion: { url in
            
            if let data = try? Data(contentsOf: url), let uiImage = UIImage(data: data) {
                pickImage = Image(uiImage: uiImage)
            }
            
        }, onCancellation: {
            
        })
    
    }
}

#Preview {
    ContentView()
}




struct CustomButtonStyle: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.title3)
      .fontWeight(.heavy)
      .frame(height: 50)
      .frame(maxWidth: .infinity)
      .background(Color.mint)
      .foregroundColor(.white)
      .cornerRadius(10)
  }
}

// Extension
extension View {
  func customButtonStyle() -> some View {
    return self
      .modifier(CustomButtonStyle())
  }
}
