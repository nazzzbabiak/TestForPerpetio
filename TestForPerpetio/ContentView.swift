//
//  ContentView.swift
//  TestForPerpetio
//
//  Created by Nazar Babyak on 15.02.2022.
//

import SwiftUI


struct PostModel: Identifiable , Codable ,Hashable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}


class DownloadfromViemModel: ObservableObject {
    
    @Published var posts: [PostModel] = []
    
    init() {
        
        getPost()
    }
    
    
    func getPost() {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        downloadData(fromURL: url) { (returnedData) in
            if let data = returnedData {
                guard let newPosts = try? JSONDecoder().decode([PostModel].self, from: data ) else {
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    self?.posts = newPosts
                }
            } else {
                print("No data to returned!")
            }
        }
    }
    
    func downloadData(fromURL url: URL , completionHandler: @escaping (_ data: Data?) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {
                print("No data!")
                completionHandler(nil)
                
                return
            }
            
            guard error == nil else {
                print("Error!: \(String(describing: error))")
                completionHandler(nil)
                
                return
            }
            guard let response = response as? HTTPURLResponse  else {
                print("Invalid response!")
                completionHandler(nil)
                
                return
            }
            
            guard response.statusCode >= 200 && response.statusCode < 300 else {
                print("Status code should be 2**, but it \(response.statusCode)")
                completionHandler(nil)
                return
            }
            
            completionHandler(data)
            
        }.resume()
    }
}


struct ContentView: View {
    
    @StateObject var vm = DownloadfromViemModel()
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                ForEach(vm.posts, id: \.self) { post in
                    VStack(alignment: .leading, spacing: 10){
                        
                        NavigationLink(destination: {
                            ZStack{
                                Color("ColorThree").ignoresSafeArea(.all)
                                VStack(alignment: .leading){
                                    Text(post.title)
                                        .font(.title)
                                        .foregroundColor(Color("ColorText"))
                                        .frame(maxWidth: .infinity)
                                        .background(Color.gray.opacity(0.11))
                                        .cornerRadius(11)
                                    VStack{
                                        Text(post.body)
                                            .font(.body)
                                            .foregroundColor(Color("ColorText"))
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .padding(5)
                                            .background(Color("ColorOne"))
                                            .cornerRadius(11)
                                        Spacer()
                                        
                                    }
                                    
                                }
                                
                                .padding()
                                
                                
                            }
                            
                        }, label: {
                            ZStack{
                                VStack{
                                    Text(post.title)
                                        .foregroundColor(Color("ColorText"))
                                        .font(.headline)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(11)
                                        .background(Color("ColorOne")).cornerRadius(11)
                                }
                                .padding(6)
                                .shadow(color: .gray, radius: 2, x: 2, y: 2)
                            }
                        })
                    }
                }
            }
            .navigationTitle("TestForPerpetio")
            .navigationBarTitleDisplayMode(.automatic)
            .navigationBarItems(leading: NavigationLink(destination: {
                Text("I try to be better!")
                    .padding()
                
            }, label: {
                Image(systemName: "person.fill")
                
            }), trailing: NavigationLink(destination: {
                
            }, label: {
                Image(systemName: "xmark")
                
            }))
            .background(Color("ColorThree").edgesIgnoringSafeArea(.all))
            .cornerRadius(10)
        }
        .accentColor(Color("ColorText"))
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
//        ContentView()
//            .colorScheme(.dark)
        
    }
}

