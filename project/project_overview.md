# Personal Timeline: A Time-Aware Second Brain

## Project Proposal

### Problem Statement
Most productivity apps focus on planning - what you should do. But for many people, especially those managing multiple responsibilities with limited resources, the real challenge isn't planning. It's remembering what actually happened, tracking where time went, and building a reliable external memory system.

Current solutions fall short:

- Calendar apps are forward-looking, designed for scheduling future events
- Note-taking apps lack time awareness and become cluttered archives
- Time-tracking apps are work-focused and require constant categorization
- Journal apps emphasize reflection over quick capture
- Habit trackers gamify behaviors rather than simply recording reality

The gap: There's no simple, distraction-free tool that captures your day as it unfolds, creates a searchable timeline of your actual activities, and helps you understand how you're really spending your time.

### Target User

#### Primary user profile:

- Income: Lower to middle income bracket
- Device: Single device user (entry-level smartphone)
- Need: Better time management and memory retention without complex systems
- Context: Managing work, family, personal tasks with limited mental bandwidth
- Tech comfort: Basic smartphone user, appreciates simplicity

#### User pain points:

- "Where did my day go?"
- "Did I take my medication this morning?"
- "What was I working on last Tuesday?"
- "I need to remember this, but I'll forget if I don't write it down NOW"

### Solution

Personal Timeline is a mobile-first app that creates a time-stamped record of your day through effortless capture and intelligent organization.

#### Core value proposition:

- Capture without friction - Add notes in seconds, no categorization required
- Time-aware by default - Everything is automatically timestamped
- Review, don't plan - Understand your patterns by looking back, not forward
- Privacy-first - All data stored locally on your device
- Optimized for reality - Built for low-end devices, works offline, respects limited resources

#### Key Features

1. Effortless Capture

  - Quick notes: Text, images, video, or audio captured in under 3 taps
  - Reflections: Longer-form entries for deeper thinking
  - Automatic timestamps: Every entry knows exactly when it was created
  - Media support: Capture thoughts in whatever format feels natural

2. Time-Aware Timeline

  - Hourly view: See your entire day laid out chronologically
  - Visual cards: Color-coded entries for quick scanning
  - Swipe navigation: Move between days with simple left/right swipes
  - No clutter: Only what you captured, no algorithmic suggestions

3. Recurring Alarms

  - Flexible scheduling: Daily, weekly, or custom patterns
  - Smart logging: Mark tasks as done/missed with optional notes
  - Pattern recognition: See which routines you're actually maintaining
  - No judgment: Just data, no streaks or guilt-inducing metrics

4. Review & Reflection

  - Daily review mode: End-of-day summary writing while scrolling your timeline
  - Optional tagging: Add organization when you have time, not during capture
  - Statistics that matter: Active hours, note counts, alarm completion
  - Weekly summaries: Bigger picture view of your patterns

5. Privacy & Performance

  - Local-first storage: Your data never leaves your device
  - Low-resource design: Optimized for entry-level smartphones
  - Offline-always: No internet required
  - Fast & responsive: Designed for 4GB RAM devices

#### User Interface Design

##### Screen 1: Timeline View (Home Screen)
Purpose: Primary interface for viewing your day
Layout:

  - Vertical scrolling timeline with time markers (hourly)
  - Color-coded cards for each entry
  - Card preview: Title + truncated content + media thumbnail
  - Date header at top
  - Floating action button (FAB) for quick capture

Interactions:

  - Scroll vertically to view entries throughout the day
  - Swipe left/right to switch between days
  - Tap card to expand/view full details
  - Tap FAB to create new entry

Visual Design:

  - Quick notes: Light blue cards
  - Reflections: Purple cards
  - Alarm logs: Green (done) / Red (missed) / Gray (skipped)
  - Minimal chrome, maximum content visibility


##### Screen 2: Quick Capture Screen
Purpose: Fastest possible note creation
Layout:

  - Full-screen minimal interface
  - Title input field (optional)
  - Content area (text/media)
  - Media selector buttons (camera, gallery, audio)
  - Type toggle: Quick note vs Reflection
  - Save button
  - 
Interactions:

  - Opens instantly from FAB
  - Auto-focuses on content field
  - One-tap media capture
  - Auto-saves on back/dismiss
  - Returns immediately to timeline

Design principle: Zero friction - get in, capture, get out

##### Screen 3: Reflection Screen
Purpose: Longer-form thoughtful entries
Layout:

  - Similar to quick capture but with:
  - Larger content area (multi-line)
  - Optional title becomes recommended
  - Subtle visual distinction (different background tone)
  - Same media support

Interactions:

  - Accessed via type toggle in capture screen
  - Encourages longer writing without forcing it
  - Same quick save & exit flow

##### Screen 4: Review Mode
Purpose: End-of-day reflection and organization
Layout:

  - Split view or bottom sheet design
  - Top: Scrollable timeline (read-only)
  - Bottom: Summary text editor + statistics panel
  - Tag editor for selected entries

Components:

  - Statistics widget showing:
    - Total logs created
    - Alarms missed/completed
    - Active hours (first to last log)
    - Note type breakdown
  
  - Summary text area for manual notes
  - Tag addition interface (chips/badges)

Interactions:

  - Tap any timeline entry to add tags
  - Write summary while referencing your day
  - View stats for context
  - Save and exit when done

Trigger: Optional reminder 30min after last log (8-11pm default, configurable)

##### Screen 5: Weekly Summary View
Purpose: Broader pattern recognition
Layout:

  - Week selector at top (swipe between weeks)
  - Aggregated statistics:
    - Total logs for the week
    - Daily breakdown (sparkline or mini-bars)
    - Alarms missed across week
    - Days with activity
    - Busiest/quietest hours
    - Most active days
  - Manual summary section
  - Quick links to daily views

Interactions:

  - Swipe between weeks
  - Tap any day to jump to that day's timeline
  - Add/edit weekly summary notes
  - View trends over time

##### Screen 6: Settings Screen
Purpose: Configuration and preferences
Sections:
  - Alarms:
    - List of all recurring alarms
    - Add/edit/delete alarms
    - Enable/disable individual alarms
    - Time and weekday configuration
  
  - Review Reminders:
    - Toggle on/off
    - Set time window (start/end)
    - Set delay after last log
    - Preview current settings

  - Display:
    - Theme selection (light/dark/system)
    - Timeline density options
    - Card preview length
 
  - Data:
    - Storage usage indicator
    - Clear old data options (future)
    - Backup/restore (future roadmap)
 
  - About:
    - App version
    - Privacy policy
    - Feedback mechanism

#### Technical Architecture
Platform: Flutter (cross-platform, optimized for Android initially)
Storage: Hive (local NoSQL database)
  - Fast on low-end devices
  - No network overhead
  - Efficient storage

Key Dependencies:
  - hive - Local storage
  - image_picker - Camera/gallery access
  - audioplayers & record - Audio capture/playback
  - video_player - Video playback
  - flutter_local_notifications - Alarm system

Data Models:

  - TimelineEntry (base for all items)
  - Note (extends TimelineEntry)
  - Alarm (recurring schedule)
  - AlarmLog (individual instances)
  - DailySummary (stats + manual summary)
  - WeeklySummary (aggregated data)

#### Development Roadmap
Phase 1: MVP (4 weeks)

  - Week 1: Data models, timeline UI, basic note capture
  - Week 2: Alarms, notifications, media support
  - Week 3: Review mode, statistics, summaries
  - Week 4: Polish, performance optimization, testing

Phase 2: Enhancements (Post-MVP)

  - AI-generated summaries
  - Cloud sync (optional)
  - Search functionality
  - Data export
  - Week-at-a-glance view
  - Emoji tags
  - iOS release
 
Phase 3: Advanced Features (Future)

  - Smart patterns/insights
  - Collaborative timelines (shared family logs)
  - Integration with calendar apps
  - Voice-to-text quick capture
  - Widget support

### Success Metrics
User engagement:

  - Daily active usage (at least one log per day)
  - Average logs per day
  - Review mode usage rate
  - Alarm completion rates
  - 
Performance:

  - App launch time < 2 seconds on entry-level devices
  - Note capture time < 5 seconds
  - Zero crashes on target device (Samsung A06)
 
User satisfaction:

  - Qualitative feedback from initial users
  - Feature usage patterns
  - Retention after first week

Competitive Advantages

  - Simplicity first: No learning curve, no setup overhead
  - Time-aware by design: Everything has context automatically
  - Optimized for constraints: Works perfectly on limited hardware
  - Privacy by default: No accounts, no cloud, no tracking
  - Capture over planning: Meets users where they actually are

### Conclusion
Personal Timeline fills a genuine gap in the productivity space by focusing on memory and awareness rather than planning and optimization. It's built for real people with real constraints - limited time, limited devices, limited patience for complex systems.

The app respects users' intelligence while removing friction, creates value through simplicity, and builds a genuine second brain that grows more valuable over time.

### Core philosophy: Your time is already valuable. We just help you remember it.
