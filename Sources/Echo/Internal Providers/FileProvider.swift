import Foundation

// MARK: - File paths and listing contents of directories

public class File {
    
    private var threshold: Int = 3
    
    private var currentTimestamp: String = ""
    
    private lazy var fileHandler: FileHandle? = {
        guard let url = echoLogURL else { return nil }
        return try? FileHandle(forWritingTo: url)
    }()
    
    // MARK: - Singleton
    
    public static let main = File()
    
    // MARK: - Paths
    
    private var documentsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    private var cachesURL: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    private var echoDocumentsDirPath: String {
        documentsURL.appendingPathComponent("echo").path
    }
    
    private var echoCachesDirPath: String {
        cachesURL.appendingPathComponent("echo").path
    }
    
    public var appSandbox: String {
        NSHomeDirectory()
    }
    
    public var echoLogDirPath: String {
        #if DEBUG
            #if targetEnvironment(simulator)
                return echoDocumentsDirPath
            #else
                return echoCachesDirPath
            #endif
        #else
        // In production just use the documents directory so it's hidden.
        // from iTunes file sharing as long as the user hasn't enabled it.
        echoDocumentsDirPath
        #endif
    }
    
    public var echoLogDirURL: URL? {
        URL(string: echoLogDirPath)
    }
    
    public var echoLogURL: URL? {
        let absoluteLogPath = "\(echoLogDirPath)/log-\(Date.getToday()).txt"
        let url = URL(fileURLWithPath: absoluteLogPath)
        return url
    }
    
    // MARK: - Listing contents
    
    public func listContentsOfAppSandbox() -> [URL] {
        return listContentsOf(path: appSandbox)
    }
    
    public func listContentsOf(path: String) -> [URL] {
        guard let appSandboxUrl = URL(string: path) else {
            return []
        }
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(
                at: appSandboxUrl,
                includingPropertiesForKeys: nil
            )
            return directoryContents
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    public func filter(contents: [URL], term: String) {
        // if you want to filter the directory contents you can do like this:
        let mp3Files = contents.filter{ $0.pathExtension == term } // "mp3"
        print("mp3 urls:",mp3Files)
        let mp3FileNames = mp3Files.map{ $0.deletingPathExtension().lastPathComponent }
        print("mp3 list:", mp3FileNames)
    }
    
    // MARK: - Identification
    
    public func isDirectory(url: URL) -> Bool {
        do {
            let resource = try url.resourceValues(forKeys: [.isDirectoryKey])
            return resource.isDirectory ?? false
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}

// MARK: - Text File Crud Operations

extension File {
    
    /// Writing to a file will also create the file if it does not exist
    /// as long as the echo dir exists the file will be created.
    
    /// Note if you write to the file, it will overwrite the file if it already exists.
    /// This is thread safe.
    func writeToEchoFile(value: String, completion: @escaping (_ succeeded: Bool) -> Void) {
        
        guard let path = echoLogURL?.path else {
            return
        }
        
        do {
            try value.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            completion(true)
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    public func writeToEndOfEchoFile(log: String) throws {
        fileHandler?.seekToEndOfFile() // Move the cursor to the end of the file
        fileHandler?.write(log.data(using: .utf8)!)
    }
    
    func readFromEchoFile() -> String {
        
        guard let path = echoLogURL?.path else {
            return ""
        }
            
        let checkValidation = FileManager.default
        var file:String
        if checkValidation.fileExists(atPath: path) {
            file = try! String(contentsOfFile: path, encoding: .utf8)
        } else {
            file = "*ERROR* \(path) does not exist."
        }
        return file
    }
}

// MARK: - Echo directory management

public extension File {
    
    func bootstrap() {
        
        // Create the echo directory
        let created = createEchoDirectoryIfNotExists()
        print("[Echo] - directory created or already exists: \(created)")

        // Clean the echo directory from unwanted files
        let cleaned = cleanEchoDirectory()
        print("[Echo] - directory cleaned: \(cleaned)")
        
        let contents = listContentsOf(path: echoLogDirPath)
        guard contents.count == threshold else {
            // Create the log file if it doesn't exist so we can write to it later
            // with writeToEndOfEchoLogFile
            /*
                log-1-1-1.txt
                log-1-1-2.txt
                log-1-1-3.txt
                log-1-1-4.txt will push out log-1-1-1.txt next app launch and so forth.
             
                optimizations could be made forsure.
                when 1-1-4 is created 1-1-1 should just be checked out.
                need more time to work on this for now it's ok.
            */
            createLogFileIfNotExists()
            return
        }
        
        print("[Echo] - Reached log limit...")
        
        // Get the oldest log file from the
        // urls provided in contents
        let oldestLogDate = contents.map {
            $0.lastPathComponent.replacingOccurrences(
                of: "log-",
                with: ""
            ).replacingOccurrences(
                of: ".txt",
                with: ""
            )
        }.min() ?? ""
        
        print("Oldest log date: \(oldestLogDate)")
        
        // Remove the oldest log file
        guard let content = contents.filter({ $0.lastPathComponent.contains("\(oldestLogDate)") }).first else {
            return
        }
        
        let removed = remove(content: content.path)
        print("[Echo] - Removed oldest log: \(removed)")
                
        // If the log files already exist
        // let's replace the oldest one with a new one
        createLogFileIfNotExists()
    }
    
    func createLogFileIfNotExists() {
        if
            let echoLogAbsolutePath = echoLogURL?.path,
            !FileManager.default.fileExists(atPath: echoLogAbsolutePath)
        {
            writeToEchoFile(
                value: ""
            ) { succeeded in
                print("Log file created: \(succeeded)")
            }
        }
    }
    
    func createEchoDirectoryIfNotExists() -> Bool {
        let manager = FileManager.default
        do {
            try manager.createDirectory(
                atPath: echoLogDirPath,
                withIntermediateDirectories: true,
                attributes: nil
            )
            return manager.fileExists(atPath: echoLogDirPath)
        }
        catch {
            return false
        }
    }
    
    // Remove all non log files like .DS_Store
    
    func cleanEchoDirectory() -> Bool {
        for content
        in listContentsOf(path: echoLogDirPath)
        where !content.lastPathComponent.contains("log-")
        {
            do {
                try FileManager.default.removeItem(atPath: content.path)
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        }
        return false
    }
    
    func remove(content atPath: String) -> Bool {
        if FileManager.default.fileExists(atPath: atPath) {
            do {
                try FileManager.default.removeItem(atPath: atPath)
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        }
        return false
    }
}

