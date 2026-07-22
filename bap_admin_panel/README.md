# BAP Admin Panel

React + Vite frontend for the BAP LMS backend (Node + Express + PostgreSQL).

Manages verticals, modules, sections, content blocks, publishing workflow,
media library, and user accounts. Consumed by the Flutter mobile learner app
via the same backend's `/api/learn/*` endpoints.

## Stack

- React 18 + Vite 5
- React Router DOM 6
- TanStack Query 5 (server state)
- Axios (HTTP)
- React Hook Form + Zod (forms)
- React Hot Toast (notifications)
- Lucide React (icons)
- CSS Modules + CSS variables (styling)

## Setup

```bash
cd bap_admin_panel
npm install
npm run dev
```

Open <http://localhost:5173>.

## Environment

`.env.development` (committed as example):

```text
VITE_API_BASE_URL=http://localhost:5000/api
VITE_APP_NAME=BAP Admin
```

The backend must be running on the URL above.

## Test users

Backend ships with three seeded test accounts (passwords set via `bcrypt.hash`
in the seed script):

| Email | Password | Role |
|---|---|---|
| personadmin@gmail.com | admin123 | admin |
| editor1@gmail.com | editor123 | editor |
| learner1@gmail.com | learner123 | user |

The `user` role has **no** admin panel access — login attempts are rejected
at the role gate.

## Scripts

- `npm run dev` — start dev server with HMR
- `npm run build` — production build to `dist/`
- `npm run preview` — preview production build

## Folder structure

See `src/` — features are self-contained under `src/features/`, layout
primitives under `src/components/layout/` and `src/layouts/`, server state
via TanStack Query (mounted in `src/App.jsx`), all HTTP via `src/api/`.
