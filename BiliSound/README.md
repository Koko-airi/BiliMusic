# BiliSound (哔哩纯音) - iOS Bilibili Music Player

A modern, high-performance iOS music player app designed for streaming music directly from Bilibili playlists with pure audio extraction, multi-version track mapping, fair session shuffle, and full lock-screen media controls.

Compatible with **iOS 17.0+ / 18.x / 26.2.1+**.

---

## Key Features

### 🎧 Feature 1: Pure "Music Player Mode" by Default (Zero Video Overhead)
- **Audio-Only Streaming**: By default, the player fetches Bilibili's DASH manifest (`fnval=16`) from the PlayURL API (`https://api.bilibili.com/x/player/wbi/playurl`) and extracts the pure audio stream (`dash.audio[0]`), completely ignoring video streams.
- **Data & Battery Efficiency**: Saves up to 85% bandwidth and CPU cycles compared to full video playback; prevents device heating and screen wake locks.
- **CDN Anti-Leech Bypass**: Automatically attaches required HTTP headers (`Referer: https://www.bilibili.com/video/<BVID>` and mobile Safari `User-Agent`) via `AVURLAssetHTTPHeaderFieldsKey` in `BilibiliAudioAssetFactory`, preventing HTTP 403 Forbidden errors from Bilibili's CDN.
- **Background Audio**: Configured with `UIBackgroundModes: audio` and `AVAudioSession(category: .playback)` for continuous playback while the phone is locked or in other apps.

---

### 🔀 Feature 2: Playback Modes (Consecutive & Random Autoplay)
Supports three playback states selectable via the transport controls or playlist header:
1. **Consecutive Order (`.sequential`)**: Plays songs 1-by-1 in standard playlist order ($1 \to 2 \to 3 \to \dots \to N$).
2. **Session Shuffle (`.shuffle`)**: Random autoplay across tracks with single-session non-repeating guarantees (see Feature 3).
3. **Repeat One (`.repeatOne`)**: Continuously loops the currently selected track/version.

---

### 🛡️ Feature 3: Single-Session Non-Repeating Guarantee
- In shuffle mode, the app tracks all songs played within the current session via `PlaySession`:
  ```swift
  let eligibleCandidates = playlist.songs.filter { !session.hasPlayed(songId: $0.id) }
  ```
- **Guaranteed Fair Play**: A song played in the current listening session **will not be picked again** until every song in the playlist has been played.
- **Smooth Loop Cycling**: When all songs in the playlist have been exhausted, the session automatically marks a cycle completion (`loopCycleCount += 1`), refreshes the pool, and avoids immediately repeating the track that ended the previous cycle.
- **Session Inspector**: Dedicated sheet (`SessionHistoryView`) displaying session elapsed time, percentage of playlist completed, chronological log of played songs, and remaining eligible tracks.

---

### 🎲 Feature 4 (Special): Multi-Version Song Mapping
Songs on Bilibili often exist in multiple formats: official studio MVs, live stadium concerts, "THE FIRST TAKE" one-takes, acoustic covers, and fingerstyle instrumentals.
- **Multi-Version Data Model**: A single `Song` entity holds an array of `[SongVersion]`:
  ```swift
  public struct SongVersion {
      public var name: String          // e.g. "Budokan Arena Live Tour"
      public var bvid: String          // e.g. "BV1p44y1575U"
      public var uploader: String      // e.g. "YOASOBI"
      public var audioQuality: String  // e.g. "192kbps DASH"
      public var isEnabled: Bool       // Toggle on/off for random pool
      public var weight: Double        // Relative probability weight
  }
  ```
- **Random Version Selection**: Whenever a song is played (via playlist tap or autoplay), `song.selectRandomVersion()` randomly selects one of its enabled versions.
- **Version Re-roll Button**: Tap the dice icon (`🎲`) in the Now Playing screen or mini bar to immediately roll a different version of the current song!
- **Version Manager Sheet**: Users can view all versions for any song, toggle specific versions on/off, adjust weights, and paste new Bilibili links to attach more versions to an existing song.

---

### 🎛️ Feature 5: Complete Music Player Controls
- **Scrubber / Progress Bar**: Interactive scrub bar (`ScrubberBar`) with live drag preview, elapsed time, and remaining time display.
- **Fast Forward 5s (`+5s`) & Rewind 5s (`-5s`)**: Quick skip buttons for rapid navigation (`gobackward.5` and `goforward.5`).
- **Next & Previous Track**: Instant track navigation.
- **Play / Pause**: Large center hero button with buffering spinner.
- **Playback Speed Selector**: Menu supporting `0.75x`, `1.0x`, `1.25x`, `1.5x`, and `2.0x`.
- **Lock Screen & Control Center**: Full integration with `MPNowPlayingInfoCenter` and `MPRemoteCommandCenter` (remote play, pause, seek, next/prev, and $\pm 5\text{s}$ skips).

---

## Project Structure

```
BiliSound/
├── BiliSound.xcodeproj/          # Complete Xcode project file
│   └── project.pbxproj
├── BiliSound/
│   ├── App/
│   │   ├── BiliSoundApp.swift    # SwiftUI App Lifecycle
│   │   └── Info.plist            # Background Audio & ATS configuration
│   ├── Models/
│   │   ├── PlaybackMode.swift    # Sequential, Shuffle, RepeatOne
│   │   ├── SongVersion.swift     # Multi-version Bilibili video metadata
│   │   ├── Song.swift            # Song entity with weighted random selection
│   │   ├── PlaySession.swift     # Single-session history & non-repeat pool
│   │   └── Playlist.swift        # Playlist collection model
│   ├── Services/
│   │   ├── BilibiliURLParser.swift   # BV ID & timestamp/part parser
│   │   ├── BilibiliAPIService.swift  # Video details & pure DASH audio API
│   │   ├── BilibiliAudioProxy.swift  # AVURLAsset headers (Referer/UA)
│   │   └── SampleData.swift          # Curated playlists with multi-versions
│   ├── Player/
│   │   ├── AudioPlayerManager.swift  # AVPlayer engine & state machine
│   │   └── NowPlayingManager.swift   # Lock Screen & RemoteCommandCenter
│   ├── Views/
│   │   ├── MainTabView.swift         # App shell & docked mini bar
│   │   ├── PlaylistsView.swift       # Library & playlist grid
│   │   ├── PlaylistDetailView.swift  # Tracks, sequential & shuffle actions
│   │   ├── FullScreenPlayerView.swift # Full-screen player experience
│   │   ├── NowPlayingMiniBar.swift   # Floating mini-player bar
│   │   ├── SongRowView.swift         # Track list item with version badges
│   │   ├── VersionManagerSheet.swift # Feature 4: Multi-version management
│   │   ├── SessionHistoryView.swift  # Feature 3: Session progress & log
│   │   ├── AddSongSheet.swift        # Paste Bilibili BV URL to import
│   │   └── Components/
│   │       ├── ScrubberBar.swift     # Feature 5: Draggable seeker
│   │       ├── GlassControls.swift   # Glassmorphic control buttons
│   │       ├── AnimatedArtworkView.swift # Rotating vinyl & ambient glow
│   │       └── VersionBadge.swift    # Version count badge (🎲 X v)
│   └── Resources/
│       └── Assets.xcassets/          # App icons & color assets
└── README.md
```

---

## Built-In Curated Sample Playlists

The app comes preloaded with curated music playlists featuring real Bilibili music videos across multiple versions:

1. **J-Pop & Anime Masterpieces**
   - *群青 (Gunjou)* - YOASOBI: Official Studio MV, THE FIRST TAKE live, Budokan arena live.
   - *Lemon* - Kenshi Yonezu: Official MV, Live Tour concert, Acoustic fingerstyle guitar.
   - *青と夏 (Ao to Natsu)* - Mrs. GREEN APPLE: Official MV, Arena live version.
2. **Jay Chou Classics (周杰伦经典)**
   - *夜曲 (Nocturne)*: Official Studio MV, 2007 World Tour live, Piano & Cello unplugged.
   - *晴天 (Sunny Day)*: Studio master, Stadium tour singalong, Acoustic fingerstyle.
   - *七里香 (Common Jasmine Orange)*: Vladivostok MV, Invincible Tour live.
3. **Electronic & Lofi Classics**
   - *Shelter* - Porter Robinson & Madeon: Anime short MV, Live tour piano edit.
   - *Bad Apple!!* - Touhou: Shadow-art classic, Wagakki band traditional instruments live.

---

## Opening and Building in Xcode

1. Open `BiliSound/BiliSound.xcodeproj` in **Xcode 15 / 16+**.
2. Select an iOS Simulator (e.g., iPhone 15 Pro, iPhone 16 Pro) or your physical iOS device.
3. Press **Cmd + R** to Build & Run.
4. If testing on a physical iPhone, select your Personal Apple Developer Team in **Signing & Capabilities**.
