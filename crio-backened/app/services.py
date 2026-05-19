import httpx
import os
import random
from app.models import SimulationResult

class WeatherService:
    @staticmethod
    async def fetch(location: str) -> str:
        api_key = os.getenv("WEATHER_API_KEY")
        if not api_key:
            return "⚠️ Weather API key missing – using simulated data."
        url = f"http://api.weatherapi.com/v1/current.json?key={api_key}&q={location}"
        try:
            async with httpx.AsyncClient() as client:
                resp = await client.get(url, timeout=8.0)
                resp.raise_for_status()
                data = resp.json()
                t = data['current']['temp_c']
                cond = data['current']['condition']['text']
                feel = data['current']['feelslike_c']
                return f"🌡️ Real: {cond}, {t}°C (feels like {feel}°C)"
        except Exception:
            # Fallback to realistic mock for demo
            return f"⚠️ Simulated weather for {location}: hot and dry (45°C)"

class TrafficSimulator:
    @staticmethod
    def get_mock_congestion(location: str) -> str:
        # Very simple mock – can be extended with time/location rules
        if "islamabad" in location.lower():
            return "Moderate traffic on main roads"
        elif "karachi" in location.lower():
            return "Severe congestion, multiple bottlenecks"
        elif "sukkur" in location.lower():
            return "Light traffic, but extreme heat"
        else:
            options = ["Light traffic", "Moderate congestion", "Heavy gridlock", "Normal flow"]
            return random.choice(options)

class SimulationService:
    async def run(self, actions: list, location: str) -> SimulationResult:
        before = TrafficSimulator.get_mock_congestion(location)
        result = {
            "route_updated": False,
            "alert_sent": False,
            "emergency_ticket_created": False,
            "outcome": "No action taken",
            "traffic_mock_before": before,
            "traffic_mock_after": before  # default
        }
        if "redirect_traffic" in actions:
            result["route_updated"] = True
        if "send_alert" in actions:
            result["alert_sent"] = True
        if "dispatch_emergency" in actions:
            result["emergency_ticket_created"] = True
        
        # Determine after state
        if result["route_updated"] and result["alert_sent"]:
            result["outcome"] = "✅ Simulation: Congestion reduced by 60%, citizens alerted."
            result["traffic_mock_after"] = "Flow improved significantly"
        elif result["route_updated"]:
            result["outcome"] = "🔄 Traffic rerouted, but no public alert."
            result["traffic_mock_after"] = "Some improvement, still slow"
        elif result["alert_sent"]:
            result["outcome"] = "📢 Alert broadcasted, but traffic remains blocked."
            result["traffic_mock_after"] = before  # unchanged
        else:
            result["outcome"] = "⚠️ No meaningful actions simulated."
        
        return SimulationResult(**result)