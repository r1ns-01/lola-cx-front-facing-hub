# Lola Blankets Training Hub

An internal CX training platform for the Lola Blankets team. A collaborative, single-page app where agents track their own progress, take notes, and stay in sync with teammates during onboarding.

## Features

- **Multi-day training curriculum** with section-level progress tracking
- **Private & public notes** per section with @mention support
- **Emoji reactions** on public notes (👍 ❤️ 👌 🙏)
- **Notification system** for mentions and reactions
- **Team progress dashboard** showing day-by-day completion across all 10 agents
- **Resource hub** with direct links to Gorgias, Shopify, Notion KB, and other tools
- **Notion integration** — each training day links out to the full curriculum in Notion

## Tech Stack

- **Frontend:** Vanilla HTML/CSS/JavaScript (single file, no build step)
- **Database:** [Supabase](https://supabase.com) (PostgreSQL + realtime)
- **Fonts:** Cormorant Garamond, DM Sans (via Google Fonts)
- **Auth:** Name-based login with `localStorage` session persistence

## Getting Started

### Prerequisites

- A Supabase project (free tier works)
- Any static file host or just a browser

### Database Setup

1. Open the [Supabase SQL Editor](https://supabase.com/dashboard/project/_/sql)
2. Paste and run the contents of [`supabase-migration.sql`](supabase-migration.sql)
3. This creates the four required tables with indexes and RLS policies:
   - `training_progress`
   - `training_notes`
   - `training_notifications`
   - `note_reactions`

### Configuration

In [index.html](index.html), replace the Supabase credentials with your own project's values:

```js
const SUPABASE_URL = 'https://your-project.supabase.co';
const SUPABASE_KEY = 'your-anon-key';
```

Update the team member list as needed:

```js
const TEAM_MEMBERS = ['Alvin', 'Ivan', 'Reena', ...];
```

### Running Locally

No build step required. Just open `index.html` in a browser:

```bash
open index.html
```

### Deployment

Deploy as a static site — upload `index.html` and the `favicon_io/` folder to any host:

- [Netlify](https://netlify.com) — drag and drop the folder
- [Vercel](https://vercel.com)
- GitHub Pages
- AWS S3 + CloudFront

No environment variables or server configuration needed.

## Project Structure

```
lola-training-hub-final/
├── index.html               # Entire application
├── supabase-migration.sql   # Database schema + RLS policies
└── favicon_io/              # Favicon assets
```

## Team Members

The hub is pre-configured for 10 agents: Alvin, Ivan, Reena, Ely, Menjie, Nathan, Adel, Cel, Brittni, Mike. Each has a unique color-coded avatar.

## Security Note

Row-Level Security is enabled on all tables but uses permissive policies — this is intentional for an internal tool. Do not expose the anon key publicly or use this setup for sensitive data.
