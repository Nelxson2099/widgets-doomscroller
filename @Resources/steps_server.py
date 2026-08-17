import http.server
import socketserver
import json
import os
import subprocess

PORT = 8088
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
STEPS_JSON_PATH = os.path.join(SCRIPT_DIR, "steps.json")
RAINMETER_EXE = r"C:\Program Files\Rainmeter\Rainmeter.exe"

class StepRequestHandler(http.server.BaseHTTPRequestHandler):
    def do_POST(self):
        if self.path in ['/api/steps', '/steps', '/']:
            content_length = int(self.headers.get('Content-Length', 0))
            post_data = self.rfile.read(content_length)
            try:
                data = json.loads(post_data.decode('utf-8'))
                
                # Format current time
                import datetime
                now_str = datetime.datetime.now().strftime("Hace 0 min (%H:%M Wi-Fi)")
                
                steps_data = {
                    "steps_today": data.get("steps_today", 7840),
                    "steps_week": data.get("steps_week", 48200),
                    "daily_goal": data.get("daily_goal", 10000),
                    "calories": data.get("calories", int(data.get("steps_today", 7840) * 0.04)),
                    "distance_km": round(data.get("steps_today", 7840) * 0.00075, 1),
                    "last_sync": now_str
                }
                
                with open(STEPS_JSON_PATH, "w", encoding="utf-8") as f:
                    json.dump(steps_data, f, indent=2)
                
                # Copy to Rainmeter skins dir
                home_dir = os.path.expanduser("~")
                target_json = os.path.join(home_dir, "Documents", "Rainmeter", "Skins", "widget doomscroller", "@Resources", "steps.json")
                with open(target_json, "w", encoding="utf-8") as f:
                    json.dump(steps_data, f, indent=2)
                
                # Signal Rainmeter
                if os.path.exists(RAINMETER_EXE):
                    subprocess.run([RAINMETER_EXE, "!CommandMeasure", "MeasureStepsScript", "ProcessSteps()", "widget doomscroller\\Steps"])
                
                self.send_response(200)
                self.send_header('Content-type', 'application/json')
                self.end_headers()
                self.wfile.write(json.dumps({"status": "ok", "message": "Steps updated successfully"}).encode('utf-8'))
                return
            except Exception as e:
                self.send_response(400)
                self.end_headers()
                self.wfile.write(str(e).encode('utf-8'))
                return
        else:
            self.send_response(404)
            self.end_headers()

def run_server():
    with socketserver.TCPServer(("", PORT), StepRequestHandler) as httpd:
        print(f"Step Sync Server running on port {PORT}...")
        httpd.serve_forever()

if __name__ == '__main__':
    run_server()
