package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

const homePageHTML = `<!DOCTYPE html>
<html>
<head><title>Load Balancer Demo</title></head>
<body>
  <h1>Load Balancer Demo</h1>
  <button onclick="sendRequest()">Send request</button>
  <ul id="results"></ul>
  <script>
    async function sendRequest() {
      const res = await fetch('/api/hit');
      const text = await res.text();
      const li = document.createElement('li');
      li.textContent = text;
      document.getElementById('results').prepend(li);
    }
  </script>
</body>
</html>`

func homePage(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/html")
	fmt.Fprint(w, homePageHTML)
	fmt.Println("Endpoint Hit: homePage")
}

func hitHandler(w http.ResponseWriter, r *http.Request) {
	hostname, err := os.Hostname()
	if err != nil {
		hostname = "unknown"
	}
	fmt.Fprintf(w, "Handled by instance: %s", hostname)
	fmt.Println("Endpoint Hit: /api/hit by", hostname)
}

func handleRequests() {
	http.HandleFunc("/", homePage)
	http.HandleFunc("/api/hit", hitHandler)
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func main() {
	handleRequests()
}
