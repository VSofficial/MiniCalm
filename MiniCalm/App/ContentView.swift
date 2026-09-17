//
//  ContentView.swift
//  MiniCalm
//
//  Created by Varun Sharma on 17/09/26.
//

import SwiftUI

struct ContentView: View {
    
    var items = [1,2,3,4]
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            List() {
                ForEach(items, id:\.self) { item in
                    Text(String(item))
                }
            }
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
