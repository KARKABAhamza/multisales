Import Instructions – Jira and Trello Backlogs

Jira (CSV Import)
1) In Jira, go to Projects → (choose your project) → Issue navigator.
2) Click the ••• menu → Import issues from CSV.
3) Upload `docs/Backlog_Jira.csv`.
4) Map fields:
   - Project → your Jira project
   - Issue Type → Issue Type
   - Summary → Summary
   - Description → Description
   - Priority → Priority
   - Labels → Labels (multi-value allowed with `;`)
   - Components → Components
   - Sprint → Map to a custom field or ignore if not using Scrum
5) Choose encoding UTF-8, delimiter comma.
6) Start import and verify created Epics/Stories/Tasks.

Trello (CSV Import)
Option A – Trello CSV Importer (Premium/Enterprise)
1) Open your Trello workspace (Premium/Enterprise).
2) Create a new board (e.g., MULTISALES Roadmap).
3) Use CSV Importer, select `docs/Backlog_Trello.csv`.
4) Map fields:
   - List → List
   - Title → Card title
   - Description → Card description
   - Labels → Labels (semicolon separated)
5) Import to create lists and cards.

Option B – Butler/Manual (if no CSV importer)
1) Create lists manually: Phase 1 – Setup, Phase 2 – Theming/Routing/Auth, Phase 3 – Public Pages, Phase 4 – Client/Admin, Phase 5 – Optimize/SEO/Deploy.
2) Copy lines from CSV and paste as cards (one per row), or use a third-party CSV-to-Trello tool.

Notes
- After import, link Epics to Stories in Jira via Epic Link if your project uses classic templates; otherwise use parent/child in team-managed projects.
- Adjust labels to match your workspace conventions (e.g., `frontend`, `backend`, `security`).
- You can split tasks further into subtasks once assigned.


