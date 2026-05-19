import google.generativeai as genai
import os
import json
import re
from app.models import MultiSourceInput, CrisisDetection, ActionPlan
from app.antigravity_trace import TraceLogger
from app.services import WeatherService

class CrisisDetectorAgent:
    def __init__(self, model):
        self.model = model
    
    async def detect(self, social_text: str, location: str, weather_data: str) -> CrisisDetection:
        prompt = f"""
You are an expert crisis detection agent.
Inputs:
- Social media: {social_text}
- Real-time weather: {weather_data}
- Location: {location}

Output ONLY valid JSON with these exact keys:
- "situation" (short crisis type, e.g., "Urban flooding", "Heatwave", "Road accident")
- "severity" (low/medium/high)
- "confidence" (0.0 to 1.0)
- "affected_area" (specific area if mentioned, otherwise the city)
- "impact_description" (one sentence)
- "reasoning_summary" (explain why you chose this situation and confidence)

Example:
{{"situation": "Urban flooding", "severity": "high", "confidence": 0.92, "affected_area": "G-10, Islamabad", "impact_description": "Roads blocked, vehicles stranded", "reasoning_summary": "Social text mentions water and stuck cars; weather shows heavy rain; high confidence."}}
"""
        response = self.model.generate_content(prompt)
        raw = response.text.strip()
        raw = re.sub(r'^```json\s*', '', raw)
        raw = re.sub(r'\s*```$', '', raw)
        data = json.loads(raw)
        return CrisisDetection(**data)

class ImpactAnalyzerAgent:
    def __init__(self, model):
        self.model = model
    
    async def analyze(self, crisis: CrisisDetection, location: str, weather_data: str) -> str:
        prompt = f"""
Crisis: {crisis.situation} (severity: {crisis.severity})
Location: {location}
Weather: {weather_data}
Write a detailed real-world consequence analysis (2-3 sentences) covering traffic, safety, infrastructure, and economy.
"""
        response = self.model.generate_content(prompt)
        return response.text.strip()

class ActionPlannerAgent:
    def __init__(self, model):
        self.model = model
    
    async def plan(self, crisis: CrisisDetection, impact: str, location: str, weather_data: str) -> ActionPlan:
        # Domain‑relevant action subsets
        domain_actions = {
            "flood": ["redirect_traffic", "send_alert", "dispatch_emergency", "deploy_pumps"],
            "heatwave": ["send_alert", "dispatch_emergency"],
            "accident": ["redirect_traffic", "dispatch_emergency"],
            "fire": ["send_alert", "dispatch_emergency", "close_road"],
            "default": ["redirect_traffic", "send_alert", "dispatch_emergency"]
        }
        # Simple keyword matching for domain
        crisis_lower = crisis.situation.lower()
        if "flood" in crisis_lower or "water" in crisis_lower:
            allowed = domain_actions["flood"]
        elif "heat" in crisis_lower:
            allowed = domain_actions["heatwave"]
        elif "accident" in crisis_lower or "collision" in crisis_lower:
            allowed = domain_actions["accident"]
        elif "fire" in crisis_lower:
            allowed = domain_actions["fire"]
        else:
            allowed = domain_actions["default"]
        
        allowed_str = ", ".join([f'"{a}"' for a in allowed])
        prompt = f"""
Crisis: {crisis.situation} (severity: {crisis.severity})
Impact: {impact}
Location: {location}
Weather: {weather_data}
Choose appropriate actions from this allowed list: [{allowed_str}]
Return JSON: {{"actions": ["action1", "action2"], "details": {{"action1": "why chosen", "action2": "why chosen"}}}}
"""
        response = self.model.generate_content(prompt)
        raw = response.text.strip()
        raw = re.sub(r'^```json\s*', '', raw)
        raw = re.sub(r'\s*```$', '', raw)
        data = json.loads(raw)
        if isinstance(data.get("actions"), str):
            data["actions"] = [data["actions"]]
        # Filter only allowed actions
        data["actions"] = [a for a in data["actions"] if a in allowed]
        return ActionPlan(**data)

class AgentOrchestrator:
    def __init__(self, api_key: str):
        genai.configure(api_key=api_key)
        model_name = os.getenv("MODEL_NAME")
        self.model = genai.GenerativeModel(model_name)
        
        self.trace = TraceLogger()
        self.detector = CrisisDetectorAgent(self.model)
        self.impact_analyzer = ImpactAnalyzerAgent(self.model)
        self.planner = ActionPlannerAgent(self.model)
    
    async def process(self, user_input: MultiSourceInput):
        self.trace.log("INPUT", user_input.dict())
        
        # Step 1: Fetch real weather (with fallback)
        weather_data = await WeatherService.fetch(user_input.location)
        self.trace.log("WEATHER_API", weather_data)
        
        # Step 2: Crisis detection (agent 1)
        crisis = await self.detector.detect(
            user_input.social_text, user_input.location, weather_data
        )
        self.trace.log("CRISIS_DETECTED", crisis.dict())
        
        # Step 3: Impact analysis (agent 2)
        impact = await self.impact_analyzer.analyze(crisis, user_input.location, weather_data)
        self.trace.log("IMPACT_ANALYSIS", impact)
        
        # Step 4: Action planning (agent 3)
        plan = await self.planner.plan(crisis, impact, user_input.location, weather_data)
        self.trace.log("ACTION_PLAN", plan.dict())
        
        # Step 5: Simulation (with traffic mock)
        from app.services import SimulationService
        sim = SimulationService()
        sim_result = await sim.run(plan.actions, user_input.location)
        self.trace.log("SIMULATION", sim_result.dict())
        
        return crisis, plan, sim_result, self.trace.get_logs()