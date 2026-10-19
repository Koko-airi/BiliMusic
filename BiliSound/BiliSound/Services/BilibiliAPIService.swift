import Foundation

public struct BiliVideoDetails: Codable {
    public let bvid: String
    public let cid: Int
    public let title: String
    public let uploader: String
    public let picUrl: String
    public let duration: TimeInterval
    public let pages: [BiliPage]
}

public struct BiliPage: Codable, Identifiable {
    public var id: Int { cid }
    public let cid: Int
    public let page: Int
    public let part: String
    public let duration: TimeInterval
}

public struct BiliAudioStreamInfo {
    public let qualityId: Int
    public let qualityDescription: String
    public let url: URL
    public let backupUrls: [URL]
    public let bandwidth: Int
    public let codecs: String
}

public enum BiliAPIError: LocalizedError {
    case invalidURL
    case networkError(String)
    case apiError(code: Int, message: String)
    case noAudioStreamFound
    case decodingError
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid Bilibili URL or BV ID."
        case .networkError(let msg):
            return "Network connection error: \(msg)"
        case .apiError(let code, let msg):
            return "Bilibili API error [\(code)]: \(msg)"
        case .noAudioStreamFound:
            return "No pure audio stream found for this video."
        case .decodingError:
            return "Failed to parse Bilibili response."
        }
    }
}

/// Service to query Bilibili APIs for video metadata and extract pure audio DASH streams (Feature 1).
public final class BilibiliAPIService {
    public static let shared = BilibiliAPIService()
    
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Headers
    
    public static let defaultHeaders: [String: String] = [
        "User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1",
        "Referer": "https://www.bilibili.com",
        "Origin": "https://www.bilibili.com"
    ]
    
    // MARK: - Fetch Video Details
    
    public func fetchVideoDetails(bvid: String, pageIndex: Int = 1) async throws -> BiliVideoDetails {
        guard let url = URL(string: "https://api.bilibili.com/x/web-interface/view?bvid=\(bvid)") else {
            throw BiliAPIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        for (key, value) in Self.defaultHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw BiliAPIError.networkError("HTTP status code invalid")
        }
        
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw BiliAPIError.decodingError
        }
        
        let code = json["code"] as? Int ?? -1
        if code != 0 {
            let msg = json["message"] as? String ?? "Unknown error"
            throw BiliAPIError.apiError(code: code, message: msg)
        }
        
        guard let dataDict = json["data"] as? [String: Any],
              let title = dataDict["title"] as? String,
              let pic = dataDict["pic"] as? String else {
            throw BiliAPIError.decodingError
        }
        
        let owner = dataDict["owner"] as? [String: Any]
        let uploader = owner?["name"] as? String ?? "Bilibili Artist"
        let duration = dataDict["duration"] as? TimeInterval ?? 0
        
        var pages: [BiliPage] = []
        if let pagesArray = dataDict["pages"] as? [[String: Any]] {
            for pageItem in pagesArray {
                let cid = pageItem["cid"] as? Int ?? 0
                let page = pageItem["page"] as? Int ?? 1
                let part = pageItem["part"] as? String ?? ""
                let pageDuration = pageItem["duration"] as? TimeInterval ?? duration
                pages.append(BiliPage(cid: cid, page: page, part: part, duration: pageDuration))
            }
        }
        
        // Find target CID based on requested pageIndex
        let targetCid: Int
        if let targetPage = pages.first(where: { $0.page == pageIndex }) {
            targetCid = targetPage.cid
        } else if let firstPage = pages.first {
            targetCid = firstPage.cid
        } else {
            targetCid = dataDict["cid"] as? Int ?? 0
        }
        
        return BiliVideoDetails(
            bvid: bvid,
            cid: targetCid,
            title: title,
            uploader: uploader,
            picUrl: pic,
            duration: duration,
            pages: pages
        )
    }
    
    // MARK: - Feature 1: Pure Audio Stream Extraction (No Video Loaded)
    
    /// Requests Bilibili DASH media streams and extracts pure audio stream URLs.
    /// fnval=16 requests DASH, where audio streams are delivered separately from video.
    /// This saves data and battery, and enables pure audio playback.
    public func fetchAudioStream(bvid: String, cid: Int) async throws -> BiliAudioStreamInfo {
        // fnval=16 (DASH format) or 80 (DASH with HDR/Dolby)
        guard let url = URL(string: "https://api.bilibili.com/x/player/wbi/playurl?bvid=\(bvid)&cid=\(cid)&fnval=16") else {
            throw BiliAPIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        for (key, value) in Self.defaultHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.setValue("https://www.bilibili.com/video/\(bvid)", forHTTPHeaderField: "Referer")
        
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw BiliAPIError.networkError("Invalid HTTP status")
        }
        
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw BiliAPIError.decodingError
        }
        
        let code = json["code"] as? Int ?? -1
        if code != 0 {
            let msg = json["message"] as? String ?? "Unknown error"
            throw BiliAPIError.apiError(code: code, message: msg)
        }
        
        guard let dataDict = json["data"] as? [String: Any],
              let dash = dataDict["dash"] as? [String: Any],
              let audioList = dash["audio"] as? [[String: Any]],
              !audioList.isEmpty else {
            throw BiliAPIError.noAudioStreamFound
        }
        
        // Sort audio streams by quality ID descending (30280: 192k > 30232: 132k > 30216: 64k)
        let sortedAudios = audioList.sorted {
            ($0["id"] as? Int ?? 0) > ($1["id"] as? Int ?? 0)
        }
        
        guard let bestAudio = sortedAudios.first,
              let baseUrlString = bestAudio["baseUrl"] as? String,
              let baseUrl = URL(string: baseUrlString) else {
            throw BiliAPIError.noAudioStreamFound
        }
        
        let qualityId = bestAudio["id"] as? Int ?? 30280
        let bandwidth = bestAudio["bandwidth"] as? Int ?? 192000
        let codecs = bestAudio["codecs"] as? String ?? "mp4a.40.2"
        
        var backupUrls: [URL] = []
        if let backups = bestAudio["backupUrl"] as? [String] {
            backupUrls = backups.compactMap { URL(string: $0) }
        }
        
        let qualityDesc: String
        switch qualityId {
        case 30280: qualityDesc = "192kbps HQ Audio"
        case 30232: qualityDesc = "132kbps Standard"
        case 30216: qualityDesc = "64kbps Low Data"
        default: qualityDesc = "\(bandwidth / 1000)kbps DASH Audio"
        }
        
        return BiliAudioStreamInfo(
            qualityId: qualityId,
            qualityDescription: qualityDesc,
            url: baseUrl,
            backupUrls: backupUrls,
            bandwidth: bandwidth,
            codecs: codecs
        )
    }
}
