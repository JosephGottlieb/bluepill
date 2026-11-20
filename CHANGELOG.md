# Changelog

All notable changes to **BluePill** (`bluepill` / `imsg`) are documented in this file.

## [Unreleased]

## [1.2.4] - 2026-11-19

### Added
- **Built-In BluePill Cloud Relay (`bluepill-server` & Homebrew):** Ported the pure Python 3 stdlib RFC 6455 TLS WebSocket tunnel client directly into `server/bluepill_server.py`. Added `bluepill-server relay-setup` (`~/.config/bluepill/relay.json` with `0600` permissions + immediate WebSocket auth check) and `bluepill-server relay-status`. `bluepill-server serve` (and `brew services start bluepill`) now connects automatically to `wss://api.bluepill.nertwork.com/tunnel/connect` when configured (`--no-relay` for local-only mode).
- **Unified Liquid Glass / Matrix / Light Web Client (`/web`):** Upgraded `WEB_UI_HTML` in `bluepill-server` with zero external CDN dependencies to match the unified BluePill Cloud Web Client design: theme switcher (`Liquid Glass`, `Matrix`, `Light`), tabbed **Messages, Notes, Calendar, Photos, and Contacts** hub, message search, New Chat modal, blue/green iMessage/SMS bubbles, inline hover tapback reaction bar, 1-click 2FA OTP copy pills, and photo lightbox.
- **Cross-Platform Packaging & Documentation Sync:** Updated `v1.2.4` across CMake, Homebrew formula (`Formula/bluepill.rb`), Arch AUR (`PKGBUILD` / `PKGBUILD.aur` / `.SRCINFO`), Debian `.deb`, Fedora `.rpm`, Windows Inno Setup `.exe`, GitHub Pages (`docs/index.html` + `sync_gh_pages.py`), and `support@nertwork.com` contact links.

### Changed
- **No more Home page:** with no conversation open, the right pane shows a short hint instead of a dashboard that repeated the top bar and the chat list. Its pieces moved:
  - The conversation count is now part of the filter (**All (N)**).
  - The history sync window (now a dropdown) and **Web UI** are in **Settings**. **Sync** is in the top bar.
  - **Mark all read** appears at the top of the **Unread** view, and Ctrl+Shift+A still works.
  - Ctrl+H still closes the open conversation.
- **Quieter top bar:** the relay status ("Connected v1.2.1 · macOS …") shows only while hovering the connection dot, and the `60d` history pill is gone.
- **Cleaner conversation header:** it's a transparent strip with the contact centered. Its buttons moved:
  - **Mute** and **Delete** were already in the chat list's hover actions, and **Read/Unread** joins them.
  - **Sync** is in the top bar, next to the filters.
  - **Top** and **Bottom** are floating ↑ / ↓ arrows. They're small and faint, in the conversation's top-right and bottom-right corners. They appear when you've scrolled away from either end, and only while the mouse moves or the list scrolls; after 1.5 s idle they fade out.
- **Faster wheel scrolling, animated jumps:**
  - **Wheel:** one notch scrolls about 110 px, speeding up to 2.5× while the wheel spins. Before, 3 notches moved about 18 px. Touchpads follow your finger.
  - **Arrows:** the ↑ / ↓ arrows animate there instead of jumping.
- **Icon-only top-bar buttons:** **New Message** is a compose icon (pencil over paper), **Settings** is the gear, and **Sync** is ↻, which spins while history syncs. Tooltips name each one, and Ctrl+N, Ctrl+, and Ctrl+R still work.
- **The message box hugs its text:** one line is as tall as the buttons beside it, and the box grows only once text wraps.
- **Message actions open on right-click:** hovering a message no longer outlines it or pops up the tapback / Reply / Copy / Delete bar. Right-click a message or photo to open the bar, and left-click elsewhere or press Esc to close it. Right-click used to copy the message; that's now the bar's **Copy** button.
- **Server URL defaults match the relay, with a separate Port field:** A server URL without a scheme now resolves to `http://` (the relay has no TLS unless started with `--tls-cert`/`--tls-key`). Settings has a separate **Port** field that shows the default `1235` greyed out, and a port typed into the URL field (`host:8080`) moves into it. When no port is given, `1235` is used for both `http://` and `https://` (enter `443` for a reverse proxy). Saved configs and env-var URLs are never rewritten, and a saved URL without a port shows its effective port (443/80) so re-saving keeps it.

### Added
- **GIFs play inline:** GIF and WebP attachments animate in the conversation and in the photo viewer (`AnimatedImage`). Animated WebP needs Qt's WebP image plugin (`qt6-imageformats`). GIFs pause while scrolled off screen.
- **Photos and emoji without text are shown without a bubble**, like iOS Messages. A photo sent on its own shows with rounded corners and no bubble behind it; a message of one to three emoji is shown large, with no bubble. Photos with a caption, and text that contains emoji, keep their bubble.
- **Tailscale relay discovery in Settings:** When `tailscale` is installed and connected, Settings lists online macOS peers, checks each for a relay on `:1235`, and fills in the URL with one click. On first run, if exactly one relay answers, it's filled in for you. If the relay isn't reachable, the dialog says the relay may be listening only on `127.0.0.1`.

### Changed
- **Inline photos keep their aspect ratio:** Photos are no longer cropped to a fixed box. Each is scaled down to fit the message column (at most 360×360 without a bubble, 320 wide inside one) and never scaled up. They're decoded at display size rather than full resolution, so large photos load faster and use far less memory. Rounded corners use `QtQuick.Effects`; with the software renderer, or where that module isn't installed, photos show with square corners.
- **Threads, like Messages on iOS and macOS:**
  - Clicking a quoted reply opens a thread view with the original message and every reply to it.
  - Choosing the original (**Show in conversation**) scrolls the timeline to it and briefly outlines it.
  - Messages that have replies show **N Replies** underneath, which opens the same view.
  - A reply box at the bottom adds a reply to the thread without leaving it (Enter sends, Shift+Enter adds a line).
  - Esc closes it.
- **Edit Contact shows the whole Mac contact:** the dialog now fills the name, phone and email from the contact on the Mac, instead of splitting the chat title. The separate **Edit Contact** button is gone.
- **Contact / conversation info:** clicking the name in the conversation header opens a read-only card over the conversation.
  - **Details:** everything the Mac has for the contact, with **✎ Edit**, or **＋ Add Contact** for an unknown number.
  - **Photos:** a grid that opens the photo viewer.
  - **Links:** each shared link, opened in your browser.
  - **Files:** other attachments, opened from there.
  - **Group chats** get the same tabs, and Esc closes the card.
  - Closing the editor (Save or Cancel) or the photo viewer goes back to the card, on the same tab. Switching conversations reloads it for the new chat.
- **Contact photos instead of initials:** `bluepill-server` serves each contact's AddressBook photo at `/api/v1/contact/<id>/avatar`. That handles the photo stored inline, with or without the leading marker byte, and the newer `Images/` file reference. The client downloads photos only for people you have chats with, 4 at a time, caches them for a day, and shows them as circles in the chat list, the pinned row and the conversation header. Under **On your Mac** it lists every other populated field: middle name, nickname, company, job title, department, all phones and emails with their labels, addresses, URLs, birthday and note. `bluepill-server` now returns these fields from the AddressBook (labels, `middleName`, `jobTitle`, `department`, `addresses`, `urls`, `note`, `birthday`), reading only the columns that exist on that macOS version.
- **Edit sent iMessages:** right-click a message you sent and choose **Edit**. The composer switches to edit mode (Enter saves, Esc cancels) and the message shows as Edited. If the Mac rejects the edit, the original text comes back, and your unsent draft is restored when you finish or cancel the edit.
- **Tailscale relay discovery in Settings:** When `tailscale` is installed and connected, Settings lists online macOS peers, checks each for a relay on `:1235`, and fills in the URL with one click. On first run, if exactly one relay answers, it's filled in for you. If the relay isn't reachable, the dialog says the relay may be listening only on `127.0.0.1`.

### Fixed
- **Dropdowns follow the theme:** the microphone and speaker pickers, and the page-size and calendar selectors, no longer render as white system widgets.
- **Server URL defaults match the relay, with a separate Port field:** A server URL without a scheme now resolves to `http://` (the relay has no TLS unless started with `--tls-cert`/`--tls-key`). Settings has a separate **Port** field that shows the default `1235` greyed out, and a port typed into the URL field (`host:8080`) moves into it. When no port is given, `1235` is used for both `http://` and `https://` (enter `443` for a reverse proxy). Saved configs and env-var URLs are never rewritten, and a saved URL without a port shows its effective port (443/80) so re-saving keeps it.
- **The pinned row shows your Mac's pinned conversations:**
  - **What changed:** it reads the Mac's pins (`GET /api/v1/pinned`) in the Mac's order, instead of showing the four most recent chats when nothing was pinned locally.
  - **Right-click:** on a pinned contact it opens the conversation menu instead of silently pinning that chat, which used to hide the other three.
  - **Pin / Unpin:** the menu has **Pin** / **Unpin**. Unpinning a Mac pin hides it here and survives restarts, and pinning any chat adds it after the Mac's pins.
  - **With nothing pinned,** the row is hidden.
- **Unsend works:** the client now tells the Mac which chat the message is in. Previously the Messages helper got an empty chat, so nothing was unsent, yet the message vanished locally and was deleted from the Mac. The message is now removed only after the Mac confirms (a helper that times out without confirming leaves it in place). Otherwise a toast says why, such as the Private API helper not being connected.
- **Edit and Unsend are offered only within 2 minutes of sending,** and only for your own iMessages. The buttons disappear once a message is older than that.
- **`bluepill-server` edit/unsend endpoints report failures:** they look up the message's chat in `chat.db` when none is given. They answer `503` when the Messages helper isn't connected, `502` when it refuses, and `404` for an unknown message, instead of always answering `200`.
- **Opening or scrolling a chat with photos no longer rebuilds the whole conversation per photo:** each photo that finished loading from the cache reset the message list, so every message was recreated and the scroll position restored again (14 times while opening one chat with 10 photos). Photos now update in place.
- **Link previews no longer save HTML pages as thumbnails:** when a site answered an `og:image` or oEmbed thumbnail URL with an HTML error or consent page, the page was saved as `*_thumb.jpg`. The preview showed an empty image area and logged "Unsupported image format" on every repaint. Thumbnails are now saved only if they decode as an image.
- **iMessage chats no longer labeled "SMS" on macOS 26:** Chat GUIDs written as `any;-;<handle>` previously fell through to `SMS`. The client now resolves a chat's service from the GUID prefix, then any chat-level `serviceName`, then the newest message's service, then participant handles. It also updates the service as newer messages arrive.
- **No more green-to-blue flash in iMessage threads:** Bubbles, the header pill, the reply bar, and the composer are green only when the service is known to be SMS or RCS. An unresolved service stays blue and its pill is hidden.
- **Service evidence is ordered by date:** a chat's service from `lastMessage` in chat metadata or from a message keeps its date, and newer evidence wins in either direction. Participant-only metadata never overrides message evidence. Chats created from a message use the embedded chat's `serviceName`, `lastMessage` and participants. A change to the selected chat's service notifies the header, and merged sibling chats keep the refined service.
- **Settings re-save never moves or invalidates an endpoint:** an unchanged primary or failover URL is kept exactly as saved (for example, `https://relay` stays on 443). Endpoint changes are compared by effective scheme, host, port and path, so an equivalent URL such as `https://relay:443` no longer discards pending iCloud Hub edits.
- **Legacy URLs keep `https://`:** scheme-less URLs from `config.json`, environment variables and the keyring keep the historical `https://` default. The new `http://` + `1235` defaults apply only to values entered in Settings.
- **`http://` relays on Tailscale and private LANs can authenticate again:** v1.2.3 only sent the password over `http://` to localhost, so the `http://` default and discovered relays could connect but every authenticated request failed. Tailscale addresses (`100.64.0.0/10`, `fd7a:115c:a1e0::/48`, `*.ts.net`) and private LAN addresses (RFC 1918, link-local, IPv6 ULA, `*.local`) are now allowed. Public hosts still need `https://`, and Settings warns before saving one over `http://`.
- **Custom-domain Tailscale names work over `http://`:** a name like `relay.tail.example.com` that isn't `*.ts.net` is trusted once it resolves only to Tailscale addresses that `tailscale status --json` lists as tailnet nodes. The range alone isn't enough, since `100.64.0.0/10` is also carrier-grade NAT space. The check runs in the background before connecting and is cached for the session.
  Requests wait for the check instead of being refused at startup, and pressing Sync or saving Settings while it runs no longer crashes the app.
- **`https://user@host` URLs keep their port:** only `ssh://` and scheme-less `user@host` are treated as SSH, so the Port field and re-saves work for URLs with user info. Endpoint paths and user names are compared case-sensitively.
- **Tailscale relay rows are keyboard-selectable** (Tab, then Return or Space), and discovery probes never buffer more than 4 KiB of a peer's reply.
- **Tailscale discovery works without MagicDNS:** if a peer's DNS name doesn't resolve (e.g. `--accept-dns=false`), the probe retries the peer's Tailscale IP.

### Documentation
- Use the Homebrew relay port `1235` everywhere the docs referred to the BluePill relay on `1234` (server.json examples, LaunchAgent plists, reverse-proxy targets, Tailscale Serve, Web UI URLs, agent playbooks). BlueBubbles' own default `1234` is still mentioned where it applies.
- Document the Settings Port field, Tailscale relay discovery, and when to enter `443` (TLS reverse proxy / Tailscale Serve).
- Note that `bluepill-server` takes its listen address from `--host` / `--port` (not `server.json`) and listens on `127.0.0.1` unless it's given `--host`.
- `docs/ARCHITECTURE.md` explains how the client resolves a chat's service for macOS 26 `any;` GUIDs.

## [1.2.3] - 2026-11-18

### Fixed
- **Sending & Delivery Receipt Reliability:** Eliminated stuck `"Sending..."` states on slow or delayed `chat.db` commits across `bluepill-server` and the Qt6 client (`_poll_wal_once` ROWID boundary tracking, atomic fallback claims, strict `tempGuid` correlation, and stale error/receipt freshness guards).
- **Voice Memo Capture, Playback & Cancellation:** Fixed voice memo recording cleanup, waveform bar extraction/retention across optimistic and server rows, audio device selection persistence & reconciliation, and clean recording cancellation.
- **Clipboard Image Staging, Popups & UI Stability:** Fixed pasted/staged image handling, popup and media viewer clipping, and message-list timeline ordering/rebuild stability (removing message-area jumping).

## [1.2.2] - 2026-11-18

### Fixed
- **iCloud Photos Daemon Auto-Heal & Live Watcher Push:** Added `cloudsync.noindex/syncstatus.plist` inspection (with `public.image` / `public.movie` UTI splits), time-separated high-CPU wedge detection, automatic `cloudd`/`photolibraryd`/`cloudphotod` healing, lightweight `_nudge_cloudphotod()` on `Refresh` (`?refresh=1`), `Sync All`, and 120s background watchdog intervals, plus Socket.IO `icloud-photos-updated` push delivery across both Qt6 and Web UI clients.
- **Native Video Support & HTTP Range Streaming:** Added iCloud Photos library video classification, duration badges, derivative poster thumbnails (`?preview=1`), `If-Range` / chunked HTTP `206 Partial Content` streaming, and native video playback in Qt6 & Web UI.
- **Fast Batch Sync & Thumbnail Retry Resilience:** Stopped calling the Messages unpurge helper on non-stub `Photos.sqlite` assets during `Sync All`, added brief server-side materialization retries for brand-new photos, and added Qt tile error retries for transient download races.

## [1.2.1] - 2026-11-16

### Fixed
- **Unified Split RCS/SMS Group Threads (`original_group_id`):** Merged sibling `RCS;+;`, `SMS;+;`, and `iMessage;+;` `chat` rows sharing `original_group_id` (or matching non-empty group display names with overlapping participants) across both `bluepill-server` (`server/bluepill_server.py`) and the Qt6 client (`src/backend.cpp`), while strictly isolating 1:1 (`style=45`) threads.
- **Active Outbound Session Routing:** Exposed sibling metadata (`originalGroupId`, `siblingGuids`, `activeSendChatGuid`) and automatically routed outbound text messages, inline replies, attachments, tapback reactions, and read-state updates to the active RCS session row instead of superseded sibling sessions.
- **Async Outgoing Delivery Error Tracking:** Monitored outgoing `chat.db` rows for post-commit `error`, `is_sent`, and `is_delivered` changes (`updated-message` + `message-send-error`), stopped prematurely marking optimistic outbound messages as `"Delivered"`, and surfaced carrier/RCS send failures (`⚠ Not Delivered` + toast) without resending failed messages.
- **Preserved Reply Target Across Canonical/Background Sync:** Guarded `onSelectedChatChanged` in `src/Main.qml` with `backend.isSameConversation(...)` so canonical sibling refreshes never clear `replyTargetGuid` or active message drafts.
- **Packaging & CI Alignment:** Synchronized `v1.2.1` metadata across CMake, `bluepill-server`, Arch `PKGBUILD` / AUR `.SRCINFO`, and `Formula/bluepill.rb`, and updated `.github/workflows/ai-pr-review.yml` to report dynamic QtTest counts.

## [1.2.0] - 2026-11-13

### Added
- **iCloud Hub Read/Write Notes & Pop-Out Modal:** Full HTML and plain-text editor with automatic debounced saving, rich attachment viewing/downloads, and an interactive full-screen Pop Out modal (`Pop Out` / `Pop In`).
- **Paginated & Full-Screen Photos, Notes & Calendar:** Enhanced navigation with custom items-per-page selectors (`24 / 60 / 120`), custom scrollbars, page navigator, and `⛶ Full Screen` presentation across macOS Photos.app gallery, Apple Notes, and Apple Calendar.
- **Customizable Notifications & 6 Audio Ding Presets (`⚙ Settings` / `Ctrl+,`):**
  - Six built-in synthesized `.wav` presets: `Classic Chime`, `Crystal Ding`, `Tri-Tone Marimba`, `Soft Pop`, `Glass Ping`, and `System Tone`.
  - In-app `🔊 Preview Ding` and `🔔 Test Alert` controls.
  - Active chat focus muting (`notificationMuteWhenActive`).
  - Startup baseline sync state (`m_initialSyncComplete`, `m_startupTimestamp`, `m_startupHighestRowId`, `notifiedMessageGuids`) to eliminate spurious startup or historical sound alerts.
- **Top-Left Connection Dot & Status Pill:** Real-time visual indicator turning **Red (`Disconnected`)** immediately when offline and **Green (`Connected`)** when online.
- **Darker Emerald RCS Sent Bubbles (`#1B5E3A`):** Vivid contrast and WCAG AA legibility for sent RCS messages against dark backgrounds.
- **Sub-Millisecond Image Copy & Paste:** Non-blocking async clipboard image copy (`<0.5ms`) via `QThreadPool` PNG compression and zero-copy Wayland clipboard paste.
- **Scheme-Less SMS Linkification:** Robust linkification for SMS shortlinks and bare domain URLs (`bit.ly`, `attn.tv`).
- **Comprehensive Unit Testing:** Expanded test suite with **66 offscreen unit tests** passing in CI.

## [1.1.0] - 2026-11-11

### Added
- **Unified Rebrand to `BluePill` (`bluepill` v1.1.0):**
  - Renamed primary binary and package to `bluepill` while installing a backward-compatible `/usr/bin/imsg -> bluepill` symlink and automatically migrating `~/.config/imsg/config.json` to `~/.config/bluepill/config.json` (`0600`).
  - Added custom vector SVG and 512x512 PNG **BluePill** desktop icon (`assets/bluepill.svg`, `assets/bluepill.png`, `docs/logo.png`).
- **Headless macOS Relay Daemon (`server/bluepill_server.py` / `brew install nertwork/tap/bluepill`):**
  - Zero-Electron (~18 MB RSS) native macOS relay reading `~/Library/Messages/chat.db` in SQLite WAL mode and `AddressBook-v22.abcddb` in `<5ms`.
  - Dual-mode outbound dispatch: supports both `IMCore` Private API helper (`localhost:45670` for instant tapbacks, unsend, edit, delete, and background read state) and Zero-SIP `osascript` fallback.
  - 100% REST + Socket.IO v4 API compatibility with legacy BlueBubbles Server (`1.9.x`).
- **Built-In BluePill Web UI (`/web` & `bluepill --webui`):**
  - Responsive dark-mode browser interface served directly by `bluepill-server` at `GET /` and `GET /web`, plus a **`🌐 Web UI`** launcher button in the desktop Home Dashboard and `bluepill --webui` CLI flag.
- **Pinned Conversations Avatar Bar (`pinnedChats`):**
  - Horizontal pinned conversation avatar row at the top of the sidebar with unread count badges, 1-click thread switching, and right-click pin/unpin toggling.
- **1-Click 2FA / OTP Verification Code Pill (`extractOtpCode`):**
  - Automatically extracts 4–8 digit verification codes and `G-XXXXXX` tokens while ignoring 4-digit calendar years (`1990..2039`), phone numbers, and URLs.
- **Edited, Expressive Send Effects & Outbound Delivery Failure Badges:**
  - Displays `"· Edited"`, `"· sent with confetti / slam / lasers / loud"`, and `"⚠ Not Delivered"` metadata directly on message bubbles.
- **Clipboard Image Paste (`Ctrl+V`) & Attachment Upload (`sendAttachment`):**
  - Pressing `Ctrl+V` inside the composer with an image on the clipboard automatically stages a PNG and sends it via `POST /api/v1/message/attachment`.
- **Direct SSH Transport Support (`ssh://user@mac-host`):**
  - Server URL field accepts `ssh://user@host` (or `user@host`) for passwordless SSH key configurations alongside `https://` endpoints.

## [1.0.0] - 2026-11-10

### Added
- Initial open-source release of the native Linux C++20 & Qt6/QML desktop and CLI client (`imsg`), featuring Socket.IO v4 real-time push, 0ms local JSON state cache, built-in Photo Lightbox & Gallery Viewer, magic-byte (`ftyp`) HEIC/AVIF transcoding, two-way read/unread sync, and Omarchy theme hot-reload.
