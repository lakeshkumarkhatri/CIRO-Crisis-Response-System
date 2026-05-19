import datetime

class TraceLogger:
    def __init__(self):
        self.logs = []
    
    def log(self, step: str, data):
        self.logs.append({
            "timestamp": datetime.datetime.now().isoformat(),
            "step": step,
            "data": data
        })
    
    def get_logs(self):
        return self.logs