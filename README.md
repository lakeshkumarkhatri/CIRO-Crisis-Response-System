# CIRO – Crisis Intelligence & Response Orchestrator

AI-powered crisis detection and emergency response platform developed for AI Seekho 2026 Hackathon.

---

## Overview

CIRO analyzes crisis-related reports and social media posts, detects emergencies using AI, evaluates impact, retrieves live weather context, and generates actionable emergency response plans.

The system is designed to support rapid crisis assessment and decision-making during disasters and public emergencies.

---

## Key Features

- AI-powered crisis detection
- Confidence scoring
- Impact analysis
- Emergency action planning
- Live Weather API integration
- Agent Trace (Antigravity Logs)
- Simulation logs
- Google Maps integration
- Cloud backend deployment
- Mobile APK support
- Web support

---

## Tech Stack

### Frontend
- Flutter

### Backend
- FastAPI (Python)

### AI
- Google Gemini API

### Cloud
- Google Cloud Run

### Maps
- Google Maps

### Weather
- WeatherAPI

### Version Control
- GitHub

---

## System Architecture

```text
Flutter App / Web
        ↓
Google Cloud Run Backend (FastAPI)
        ↓
Gemini AI + Weather API + Crisis Agents
        ↓
Response + Logs + Simulations
```

---

## Workflow

1. User submits crisis report or social media text
2. Backend retrieves contextual weather data
3. AI detects and classifies crisis
4. Impact analysis is generated
5. Emergency response actions are proposed
6. Simulation and trace logs are recorded
7. Results displayed in web and mobile app

---

## Deployment

### Backend
Google Cloud Run

### Mobile
Flutter APK supported

---

## Local Setup

### Frontend

```bash
cd crio-frontend
flutter pub get
flutter run
```

### Backend

```bash
cd crio-backened
venv\Scripts\activate
uvicorn app.main:app --reload
```

---

## Environment Variables

Create `.env` inside backend:

```env
GOOGLE_API_KEY=your_gemini_api_key
MODEL_NAME=models/gemini-3.1-flash-lite
WEATHER_API_KEY=your_weather_api_key
```

---

## Contributors

- Lakesh Kumar
- Masood Kolachi

---

## Hackathon

Developed for **AI Seekho 2026 Hackathon**.