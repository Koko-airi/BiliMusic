import Foundation

/// Curated sample playlists loaded with real Bilibili music videos featuring multiple versions (Feature 4).
public struct SampleData {
    public static var defaultPlaylists: [Playlist] {
        [
            jpopPlaylist,
            jayChouPlaylist,
            lofiBeatsPlaylist
        ]
    }
    
    // MARK: - J-Pop & Anime
    public static let jpopPlaylist: Playlist = {
        let gunjou = Song(
            title: "群青 (Gunjou)",
            artist: "YOASOBI",
            album: "THE BOOK",
            artworkUrl: "https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=600&auto=format&fit=crop&q=80",
            versions: [
                SongVersion(
                    name: "Official Studio MV",
                    bvid: "BV15k4y1q7g2",
                    uploader: "YOASOBI Official",
                    duration: 262,
                    audioQuality: "192kbps DASH",
                    picUrl: "https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=600&auto=format&fit=crop&q=80"
                ),
                SongVersion(
                    name: "THE FIRST TAKE (Live One-Take)",
                    bvid: "BV1F54y1s7S8",
                    uploader: "THE FIRST TAKE",
                    duration: 254,
                    audioQuality: "192kbps HQ",
                    picUrl: "https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=600&auto=format&fit=crop&q=80"
                ),
                SongVersion(
                    name: "Budokan Arena Live Tour",
                    bvid: "BV1p44y1575U",
                    uploader: "YOASOBI Live",
                    duration: 275,
                    audioQuality: "Live Soundboard",
                    picUrl: "https://images.unsplash.com/photo-1465847899084-d164df4dedc6?w=600&auto=format&fit=crop&q=80"
                )
            ]
        )
        
        let lemon = Song(
            title: "Lemon",
            artist: "米津玄師 (Kenshi Yonezu)",
            album: "STRAY SHEEP",
            artworkUrl: "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=600&auto=format&fit=crop&q=80",
            versions: [
                SongVersion(
                    name: "Official MV",
                    bvid: "BV1ws411A7z5",
                    uploader: "Kenshi Yonezu Official",
                    duration: 275,
                    audioQuality: "192kbps DASH",
                    picUrl: "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=600&auto=format&fit=crop&q=80"
                ),
                SongVersion(
                    name: "Live Tour Concert",
                    bvid: "BV1tb411q7sF",
                    uploader: "Live Archive",
                    duration: 290,
                    audioQuality: "HQ Live",
                    picUrl: "https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=600&auto=format&fit=crop&q=80"
                ),
                SongVersion(
                    name: "Acoustic Fingerstyle Guitar",
                    bvid: "BV1ab41147u8",
                    uploader: "Guitar Solo UP",
                    duration: 260,
                    audioQuality: "Acoustic Hi-Fi",
                    picUrl: "https://images.unsplash.com/photo-1510915361894-db8b60106cb1?w=600&auto=format&fit=crop&q=80"
                )
            ]
        )
        
        let aoToNatsu = Song(
            title: "青と夏 (Ao to Natsu)",
            artist: "Mrs. GREEN APPLE",
            album: "Attitude",
            artworkUrl: "https://images.unsplash.com/photo-1518609878373-06d740f60d8b?w=600&auto=format&fit=crop&q=80",
            versions: [
                SongVersion(
                    name: "Official Studio MV",
                    bvid: "BV1ks411p767",
                    uploader: "Mrs. GREEN APPLE",
                    duration: 270,
                    audioQuality: "192kbps DASH"
                ),
                SongVersion(
                    name: "Arena Concert Live Version",
                    bvid: "BV1oW4y1M7mF",
                    uploader: "Rock In Japan Fest",
                    duration: 285,
                    audioQuality: "Live Multi-track"
                )
            ]
        )
        
        return Playlist(
            name: "J-Pop & Anime Masterpieces",
            description: "Top modern J-Pop and Anime theme songs with multi-version live and acoustic arrangements.",
            coverUrl: "https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=600&auto=format&fit=crop&q=80",
            songs: [gunjou, lemon, aoToNatsu]
        )
    }()
    
    // MARK: - Jay Chou Collection
    public static let jayChouPlaylist: Playlist = {
        let nocturne = Song(
            title: "夜曲 (Nocturne)",
            artist: "周杰伦 (Jay Chou)",
            album: "十一月的萧邦 (November's Chopin)",
            artworkUrl: "https://images.unsplash.com/photo-1507838153414-b4b713384a76?w=600&auto=format&fit=crop&q=80",
            versions: [
                SongVersion(
                    name: "Official Studio MV",
                    bvid: "BV1GJ411x7h7",
                    uploader: "杰威尔音乐JVR",
                    duration: 228,
                    audioQuality: "192kbps DASH"
                ),
                SongVersion(
                    name: "Super Live Tour Concert",
                    bvid: "BV1s7411i7mK",
                    uploader: "Jay Tour Vault",
                    duration: 240,
                    audioQuality: "Live Soundboard"
                ),
                SongVersion(
                    name: "Piano & Cello Unplugged Cover",
                    bvid: "BV19x411p7tq",
                    uploader: "Classical Piano UP",
                    duration: 215,
                    audioQuality: "Hi-Fi Instrumental"
                )
            ]
        )
        
        let sunnyDay = Song(
            title: "晴天 (Sunny Day)",
            artist: "周杰伦 (Jay Chou)",
            album: "叶惠美 (Ye Hui Mei)",
            artworkUrl: "https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=600&auto=format&fit=crop&q=80",
            versions: [
                SongVersion(
                    name: "Studio Original",
                    bvid: "BV1ux411S7qX",
                    uploader: "杰威尔音乐JVR",
                    duration: 269,
                    audioQuality: "192kbps DASH"
                ),
                SongVersion(
                    name: "Carnival Tour Stadium Singalong",
                    bvid: "BV1bx411a7yY",
                    uploader: "World Tour Archive",
                    duration: 280,
                    audioQuality: "Live Concert 48kHz"
                ),
                SongVersion(
                    name: "Acoustic Fingerstyle Arrangement",
                    bvid: "BV13x411T7mE",
                    uploader: "Guitar Master UP",
                    duration: 250,
                    audioQuality: "Studio Clean"
                )
            ]
        )
        
        let qiLiXiang = Song(
            title: "七里香 (Common Jasmine Orange)",
            artist: "周杰伦 (Jay Chou)",
            album: "七里香",
            artworkUrl: "https://images.unsplash.com/photo-1465847899084-d164df4dedc6?w=600&auto=format&fit=crop&q=80",
            versions: [
                SongVersion(
                    name: "Official MV",
                    bvid: "BV1jx411T77e",
                    uploader: "杰威尔音乐JVR",
                    duration: 299,
                    audioQuality: "192kbps DASH"
                ),
                SongVersion(
                    name: "The Invincible Live Concert",
                    bvid: "BV18t4y1U7rB",
                    uploader: "Concert Live HD",
                    duration: 310,
                    audioQuality: "Live Stadium Mix"
                )
            ]
        )
        
        return Playlist(
            name: "Jay Chou Classics (周杰伦经典)",
            description: "Timeless masterpieces with studio masters, concert live singalongs, and fingerstyle covers.",
            coverUrl: "https://images.unsplash.com/photo-1507838153414-b4b713384a76?w=600&auto=format&fit=crop&q=80",
            songs: [nocturne, sunnyDay, qiLiXiang]
        )
    }()
    
    // MARK: - Lofi Beats
    public static let lofiBeatsPlaylist: Playlist = {
        let shelter = Song(
            title: "Shelter",
            artist: "Porter Robinson & Madeon",
            album: "Shelter",
            artworkUrl: "https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=600&auto=format&fit=crop&q=80",
            versions: [
                SongVersion(
                    name: "Official Anime Film MV",
                    bvid: "BV1gs411q752",
                    uploader: "Porter Robinson",
                    duration: 219,
                    audioQuality: "192kbps DASH"
                ),
                SongVersion(
                    name: "Shelter Live Tour Piano Edit",
                    bvid: "BV1Ex411w7Q6",
                    uploader: "EDM Live Sets",
                    duration: 235,
                    audioQuality: "Live Soundboard"
                )
            ]
        )
        
        let badApple = Song(
            title: "Bad Apple!!",
            artist: "Nomico / Alstroemeria Records",
            album: "Lovelight",
            artworkUrl: "https://images.unsplash.com/photo-1534447677768-be436bb09401?w=600&auto=format&fit=crop&q=80",
            versions: [
                SongVersion(
                    name: "Shadow-Art MV Classic",
                    bvid: "BV1fx411c7mD",
                    uploader: "Touhou Nostalgia",
                    duration: 218,
                    audioQuality: "192kbps DASH"
                ),
                SongVersion(
                    name: "Wagakki Band Live (Traditional Japanese Instruments)",
                    bvid: "BV16x411A78B",
                    uploader: "Wagakki Live",
                    duration: 230,
                    audioQuality: "Live Hi-Res"
                )
            ]
        )
        
        return Playlist(
            name: "Electronic & Lofi Classics",
            description: "Energetic electronic tracks and iconic melodies with live orchestra and acoustic edits.",
            coverUrl: "https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=600&auto=format&fit=crop&q=80",
            songs: [shelter, badApple]
        )
    }()
}
