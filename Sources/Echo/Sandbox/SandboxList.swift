//
//  SwiftUIView.swift
//  
//
//  Created by Adam Dahan on 2021-07-07.
//

import SwiftUI
import QuickLook

@available(iOS 14.0, *)
public struct SandboxList: View {

    private let urls: [URL]
    
    public init(urls: [URL]) {
        self.urls = urls
    }
    
    var bundleVersion: String {
        guard
            let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String,
            let bundleNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        else {
            return ""
        }
        return "\(bundleNumber).\(version)"
    }
    
    var bundleIdentifier: String {
        guard let identifier = Bundle.main.bundleIdentifier else {
            return ""
        }
        return identifier
    }
    
    @State private var showingSheet = false
    
    @State private var textFromSelectedDocumentTextFile: String = ""
    
    public var body: some View {
        VStack {
            Rectangle()
                .fill(Color.green.opacity(0.1))
                .frame(width: UIScreen.main.bounds.size.width, height: 150)
                .overlay(
                    HStack {
                        Text(bundleVersion)
                            .font(.headline)
                        Spacer()
                        Text(bundleIdentifier)
                            .font(.subheadline)
                    }.padding()
                )
            List(urls, id: \.self) { url in
                if Document(url: url).isDirectory {
                    NavigationLink(destination:
                        SandboxList(urls: Document(url: url).listContents)
                                    .listStyle(PlainListStyle())
                    ) {
                        HStack {
                            DocumentThumbnailView(document: Document(url: url))
                            Text(Document(url: url).name)
                            Spacer()
                        }
                    }
                } else {
                    HStack {
                        DocumentThumbnailView(document: Document(url: url))
                        Text(Document(url: url).name)
                        Spacer()
                    }.onTapGesture {
                        if Document(url: url).name.contains("txt") {
                            do {
                                self.textFromSelectedDocumentTextFile = try String(contentsOfFile: Document(url: url).url.path)
                                print(self.textFromSelectedDocumentTextFile)
                                self.showingSheet.toggle()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
            }
        }
        .padding([.top, .bottom], 10)
        .sheet(isPresented: $showingSheet) {
            NavigationView {
                TextView(showingSheet: $showingSheet, text: $textFromSelectedDocumentTextFile)
            }
        }
    }
}

// Document thumbnail view

@available(iOS 14.0, *)
struct Document: Identifiable {
    var id: URL {
        url
    }
    
    private let fileProvider = File.main
    
    let url: URL
    
    var name: String {
        url.lastPathComponent
    }
    
    var isDirectory: Bool {
        do {
            let resource = try url.resourceValues(forKeys: [.isDirectoryKey])
            return resource.isDirectory ?? false
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    var listContents: [URL] {
        fileProvider.listContentsOf(path: url.path)
    }
    
    var availablePaths: [String] {
        var paths: [String] = []
        for url in listContents {
            do {
                let _ = try url.resourceValues(forKeys: [.isDirectoryKey])
                // print("Sandbox: \(url.lastPathComponent) isDirectory: \(resource.isDirectory)")
                paths.append("\(url.lastPathComponent)")
            } catch {
                print(error.localizedDescription)
            }
        }
        return paths
    }
    
    func generateThumbnail(
        size: CGSize,
        scale: CGFloat,
        completion: @escaping (UIImage) -> Void
    ) {
        let request = QLThumbnailGenerator.Request(
            fileAt: url,
            size: size,
            scale: scale,
            representationTypes: .all
        )
        
        let generator = QLThumbnailGenerator.shared
        generator.generateRepresentations(for: request) { thumbnail, _, error in
            if let thumbnail = thumbnail {
                print("\(name) thumbnail generated")
                completion(thumbnail.uiImage)
            } else if let error = error {
                print("\(name) - \(error)")
            }
        }
    }
}


@available(iOS 14.0, *)
struct DocumentThumbnailView: View {
    
    let document: Document
    
    var thumbnailSize = CGSize(width: 30, height: 30)
    
    @State var thumbnail = Image(systemName: "doc")
    @Environment(\.displayScale) var displayScale: CGFloat
    
    var body: some View {
        thumbnail
            .onAppear {
                document.generateThumbnail(
                    size: thumbnailSize,
                    scale: displayScale
                ) { uiImage in
                    DispatchQueue.main.async {
                        self.thumbnail = Image(uiImage: uiImage)
                    }
                }
            }
    }
}

struct PlainGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .center) {
            configuration.label
                .padding()
            configuration.content
        }
        .background(Color(.systemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
