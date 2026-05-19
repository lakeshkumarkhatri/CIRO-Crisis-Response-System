from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
import os
from app.models import MultiSourceInput
from app.agents import AgentOrchestrator

load_dotenv()
GOOGLE_API_KEY = os.getenv("GOOGLE_API_KEY")
if not GOOGLE_API_KEY:
    raise ValueError("Missing GOOGLE_API_KEY in .env")

app = FastAPI(title="CIRO - Crisis Intelligence & Response Orchestrator")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

orchestrator = AgentOrchestrator(GOOGLE_API_KEY)

@app.get("/health")
async def health():
    return {"status": "ok"}

@app.post("/analyze")
async def analyze_crisis(input_data: MultiSourceInput):
    try:
        crisis, plan, sim, trace = await orchestrator.process(input_data)
        return {
            "crisis": crisis.dict(),
            "action_plan": plan.dict(),
            "simulation": sim.dict(),
            "agent_trace": trace
        }
    except Exception as e:
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=str(e))