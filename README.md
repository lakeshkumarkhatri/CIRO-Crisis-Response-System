# CIRO – Crisis Intelligence & Response Orchestrator

**Submission for:** AISeekho 2026 – Challenge 3: Crisis Intelligence & Response Orchestrator (CIRO)

**Team Members:**
- Masood – Backend, Gemini integration, simulation, Flutter UI
- Lakesh Kumar – Weather API integration, multi-agent structure, documentation

---

## Overview

CIRO is an **agentic AI system** that turns unstructured social media posts into actionable crisis responses. It automatically:

1. Ingests a user's crisis description (noisy text, Urdu/Roman-Urdu supported)
2. Fetches **real-time weather** for the given location
3. Uses **Google Gemini** (Antigravity) to:
   - Detect the crisis type, severity, confidence, and affected area
   - Analyse real-world impact
   - Plan coordinated response actions (traffic rerouting, alerts, emergency dispatch)
4. **Simulates** the execution of those actions (route updates, alert sending, ticket creation)
5. Shows the **before/after** state and a full **agent trace** (every reasoning step)

The system is built as a **mobile-first Flutter app** with a **FastAPI backend** orchestrated by Google Gemini — fully complying with the mandatory **Antigravity** requirement.

---

## Architecture

```
[Flutter Mobile App]
       │
       │  HTTP POST /analyze
       ▼
[FastAPI Backend]
       │
       ├── WeatherAPI.com  (real-time weather)
       │
       ├── Google Gemini  (Antigravity orchestrator)
       │     ├── CrisisDetectorAgent
       │     ├── ImpactAnalyzerAgent
       │     └── ActionPlannerAgent
       │
       └── SimulationService  (mock traffic + action outcome)
       │
       ▼
[Response JSON]  →  Flutter displays crisis, actions, simulation, and agent trace
```

All reasoning steps are logged in the **agent trace** (visible in the mobile app), proving Antigravity-powered multi-agent planning and tool integration.

---

## Features & Challenge Requirements

| Requirement | Implementation |
|---|---|
| Multi-source input | User social text + real-time weather API (no manual entry) |
| Event detection | Gemini identifies crisis type, severity, confidence, affected area, and produces a reasoning summary |
| Impact analysis | Gemini explains real-world consequences (traffic, safety, infrastructure) |
| Action planning | Gemini dynamically selects from: `redirect_traffic`, `send_alert`, `dispatch_emergency`, `close_road`, `deploy_pumps` |
| Action simulation | Route updated, alert sent, emergency ticket created — with before/after traffic mock |
| Outcome visualization | Dedicated result screen: crisis card, actions card, simulation outcome, and agent trace |
| Agentic workflow | Three distinct Gemini-powered agents; full trace of every reasoning step |
| Google Antigravity | Gemini 1.5 Flash is the core orchestrator for reasoning and tool use |
| Urdu / Roman Urdu support | Gemini understands Urdu natively — tested with *"G-10 mein pani bhar gaya"* |

---

## Tools & APIs

| Tool / API | Purpose |
|---|---|
| Google Gemini (`gemini-1.5-flash`) | Primary Antigravity orchestrator |
| WeatherAPI.com | Real-time weather (free tier) |
| FastAPI | Async backend framework |
| Flutter | Cross-platform mobile frontend |
| OpenStreetMap (`flutter_map`) | Free interactive map (optional) |
| Mock traffic simulator | Location-based congestion simulation |

---

## Setup Instructions

### Prerequisites

- Python 3.9+
- Flutter SDK (Chrome for web testing, or Android emulator)
- Google Gemini API key — free from [Google AI Studio](https://aistudio.google.com/)
- WeatherAPI.com key — free tier

---

### Backend (FastAPI)

```bash
cd crio-backened
python -m venv venv

# Windows
.\venv\Scripts\Activate.ps1

# macOS / Linux
source venv/bin/activate

pip install -r requirements.txt
```

Create a `.env` file in the `crio-backened` directory:

```env
GOOGLE_API_KEY=AIza...YOUR_KEY...
WEATHER_API_KEY=YOUR_WEATHER_KEY
```

Start the server:

```bash
uvicorn app.main:app --reload --port 8000
```

Test with PowerShell:

```powershell
Invoke-RestMethod -Uri http://localhost:8000/analyze `
  -Method Post `
  -ContentType "application/json" `
  -Body '{"social_text":"Flood","location":"Islamabad"}'
```

---

### Frontend (Flutter)

```bash
cd ciro-frontend
flutter pub get
flutter run -d chrome        # or: flutter run  (for emulator / device)
```

The app opens in your browser. Use Chrome's device emulation for a mobile view. Enter a crisis description and location, then tap **"Detect & Respond"**.

---

## API Reference

### `POST /analyze`

**Request body:**

```json
{
  "social_text": "Very hot, people fainting",
  "location": "Sukkur"
}
```

**Response (abbreviated):**

```json
{
  "crisis": {
    "situation": "Heatwave",
    "severity": "high",
    "confidence": 0.95,
    "affected_area": "Sukkur",
    "impact_description": "...",
    "reasoning_summary": "..."
  },
  "action_plan": {
    "actions": ["send_alert", "dispatch_emergency"],
    "details": {}
  },
  "simulation": {
    "route_updated": false,
    "alert_sent": true,
    "emergency_ticket_created": true,
    "outcome": "...",
    "traffic_mock_before": "...",
    "traffic_mock_after": "..."
  },
  "agent_trace": []
}
```

---

## Antigravity Logs — Agent Trace

Every request generates a timestamped trace of all decisions. Example (abbreviated):

```json
[
  { "step": "INPUT",          "data": { "social_text": "Flood", "location": "G-10" } },
  { "step": "WEATHER_FETCH",  "data": "Heavy rain, 22°C in G-10" },
  { "step": "CRISIS_DETECTED","data": { "situation": "Urban flooding", "confidence": 0.92 } },
  { "step": "IMPACT_ANALYSIS","data": "Roads blocked, vehicles stranded..." },
  { "step": "ACTION_PLAN",    "data": { "actions": ["redirect_traffic", "send_alert"] } },
  { "step": "SIMULATION",     "data": { "route_updated": true, "alert_sent": true } }
]
```

These logs are shown inside the Flutter app (expandable "Agent Trace" section).

---

## Agentic vs. Non-Agentic Comparison

| Aspect | Heuristic / Non-Agentic | CIRO (Agentic) |
|---|---|---|
| Crisis detection | Keyword matching ("flood" → always flooding) | Gemini understands context, severity, and real weather |
| Action selection | Fixed rules (always same alert) | Dynamically chosen based on crisis type and impact |
| Novel inputs | Fails or returns generic response | Adapts — low-confidence structured output still returned |
| Tool use | No external data | Real-time weather API integrated automatically |
| Transparency | Black box | Full agent trace of every reasoning step |

The system demonstrates **observation → reasoning → decision → action → evaluation** — not just pre-programmed responses.

---

## Cost & Scalability

| Item | Details |
|---|---|
| Gemini API (free tier) | 60 requests/min, 1,500/day — sufficient for demo |
| WeatherAPI.com (free) | 1,000 calls/day |
| Estimated cost per request | ~$0.0002 (Gemini + WeatherAPI) |
| Cost for 1,000 daily users | ~$0.20/day |

**Scaling path:**
- Redis cache for weather data to reduce API calls
- Celery queue for async processing
- Optimised Gemini prompts to reduce token usage
- Cloud deployment (AWS / GCP) with auto-scaling

---

## Robustness & Edge Cases

| Scenario | Handling |
|---|---|
| Missing location | Returns graceful generic message |
| Nonsense input ("I like pizza") | Returns structured response with low confidence |
| Weather API timeout | Falls back to realistic simulated weather string |
| Gemini quota error (429) | `tenacity` retry logic — 3 attempts with exponential backoff |

Demo video includes an edge case walkthrough.

---

## Submission Deliverables

| Item | Link |
|---|---|
| Mobile App APK | [Download from Google Drive](https://drive.google.com/drive/folders/1ZRTqUozx2U4HNFI7Udn8Y1KRNqMSvXzr?usp=sharing) |
| GitHub Repository | [github.com/lakeshkumarkhatri/CIRO-Crisis-Response-System](https://github.com/lakeshkumarkhatri/CIRO-Crisis-Response-System) |
| Demo Video | [Watch on Google Drive](https://drive.google.com/file/d/1SXJyXcFaGaUI4i4h9McFHFzetT8qiwKS/view?usp=drive_link) |
| Antigravity Usage Video | [Watch on Google Drive](https://drive.google.com/file/d/1g4qFht_EzSkJR5zAdoxON5jhYbq7AmGj/view?usp=drive_link) |

---

## Team Contributions

| Member | Contributions |
|---|---|
| Masood | Backend agent orchestration, Gemini integration, simulation logic, Flutter UI, video production |
| Lakesh Kumar | Weather API integration, multi-agent structure, README, edge case testing |

---

## Limitations & Assumptions

- Weather API requires valid city/area names (works for major Pakistani cities).
- Traffic simulation is mock — no live Maps API, but the architecture supports it.
- No authentication — designed for single-user demo.
- All action simulations are non-destructive (no real emergency systems are called).

---

## Conclusion

CIRO transforms raw social media posts into simulated crisis responses powered by Google Antigravity (Gemini). It satisfies all mandatory requirements for Challenge 3, demonstrates a clear agentic workflow, and is fully functional as a mobile app.

---

*Built with ☕ during the AISeekho Hackathon 2026.*
