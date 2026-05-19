from pydantic import BaseModel
from typing import List, Optional

class MultiSourceInput(BaseModel):
    social_text: str
    location: str = "Lahore"
    # No weather_alert – now fully automatic

class CrisisDetection(BaseModel):
    situation: str
    severity: str          # low, medium, high
    confidence: float      # 0-1
    affected_area: str     # e.g., "G-10, Islamabad"
    impact_description: str
    reasoning_summary: str # explains why this crisis and confidence

class ActionPlan(BaseModel):
    actions: List[str]
    details: dict

class SimulationResult(BaseModel):
    route_updated: bool
    alert_sent: bool
    emergency_ticket_created: bool
    outcome: str
    traffic_mock_before: str   # e.g., "Heavy congestion"
    traffic_mock_after: str    # e.g., "Flow improved"