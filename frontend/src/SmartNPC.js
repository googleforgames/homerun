/*
 Copyright 2025 Google LLC

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

// The baseball demo leverages a smartNPC code base to get back NPC 'coach' dialog options as well
// as gameplay state updates from the backend.
class SmartNPC {
  constructor(config) {
    this.apiKey = config.apiKey
    this.apiURL = config.apiURL
    this.wsURL = config.wsURL
    this.wsQueue = []
    this.gameServer = null
    setInterval(() => { this.check_websocket_queue() }, 1000)
  }

  // Invoke Game Logic HTTP GET API
  invoke_game_api_get(endpoint /* teams, lineup, rosters*/, session_id, player_id, team_id) {
    const client = new XMLHttpRequest();
    var path = ""
    if (session_id != "" && player_id != "") {
      path = `${session_id}/${player_id}/${team_id}`
    } else {
      path = team_id
    }
    console.log(`invoke_game_api_get:${this.apiURL}/game/${endpoint}/${path}`)
    client.open("GET", `${this.apiURL}/game/${endpoint}/${path}`, false);
    client.setRequestHeader("X-API-KEY", this.apiKey);
    client.withCredentials = false
    client.send("");
    return client.response
  }

  // Invoke Game Logic HTTP POST API
  invoke_game_api_post(endpoint /* teams, lineup, rosters*/, session_id, player_id, team_id, data) {
    const client = new XMLHttpRequest();
    console.log(`invoke_game_api_post:${this.apiURL}/game/${endpoint}`)
    client.open("POST", `${this.apiURL}/game/${endpoint}`, false);
    client.setRequestHeader("Content-Type", "application/json");
    client.setRequestHeader("X-API-KEY", this.apiKey);
    client.withCredentials = false
    client.send(JSON.stringify(data));
    return client.response
  }

  // Set up websocket 
  setup_websocket(response_handler) {
    console.log(">> opening websocket...")
    if (this.gameServer == null || this.gameServer.readyState != WebSocket.OPEN) {
      console.log(">> game_server is null, opening new WebSocket")
      try {
        // In testing the websocket occasionally disconnected unexpectedly, hence use
        // a queue with automated reconnects instead of sending directly
        this.gameServer = new WebSocket(this.wsURL);
        console.log(`>> attempting new websocket connection, initial state: ${this.gameServer.readyState}`)

        // Websocket event handlers
        this.gameServer.onclose = ((event) => {
          console.log(`*** Closing WebSocket ***`)
          // Attempt to re-open the websocket
          this.setup_websocket(response_handler)
          console.log(event)
        })

        this.gameServer.onopen = ((event) => {
          console.log(`*** WebSocket Opened:${JSON.stringify(event)}`)
        })

        this.gameServer.onmessage = (event) => {
          console.log("*** response_received ***")
          response_handler(JSON.parse(event.data))
        };

      } catch (e) {
        console.log(`*** websocket failed:${e}`)
        throw e
      }
    }
  }

  check_websocket_queue() {
    while (this.wsQueue.length > 0) {
      // Make sure the websocket is still open
      if (!this.gameServer || this.gameServer.readyState != WebSocket.OPEN) {
        console.log(`check_websocket_queue: couldn't send data because game_server=${(!this.gameServer)} and game_server.readyState=${this.gameServer.readyState}`)
        return
      }
      // Pop a request off the queue and send it over the websocket connection
      var request = this.wsQueue.pop()
      console.log(`>> sending request to LLM: ${request}`)
      this.gameServer.send(request)
    }
  }

  // Get Team Information from the backend databse
  // Args:
  //  team_id: "all" to return all teams.
  //  session_id: "" when fetching all teams
  //  player_id: "" when fetching all teams
  GetTeams(team_id /* all or team_id */,
    session_id,
    player_id) {
    const resp = this.invoke_game_api_get("teams", session_id, player_id, team_id)
    const all_teams_json = JSON.parse(resp)
    var all_teams = []
    console.log(`==> get_teams()`)
    for (var index in all_teams_json) {
      const team = all_teams_json[index]
      console.log(all_teams_json[index])
      all_teams.push(
        {
          "title": team["team_name"],
          "text": team["description"],
          "roster": team["roster"],
          "lineup": team["default_lineup"],
          "id": team["team_id"]
        }
      )
    }
    return all_teams
  }

  UpdateLineup(team_id /* all or team_id */,
    session_id,
    player_id,
    lineup) {
    const data = {
      "team_id": team_id,
      "player_id": player_id,
      "lineup": lineup,
      "session_id": session_id
    }
    return this.invoke_game_api_post("lineup", session_id, player_id, team_id, data)
  }

  /* ==============================
    Game Logic
  ============================== */

  // request LLM reponse for the next turn over websocket
  GetTacticsWS(
    player_team_id,
    computer_team_id,
    scene_id,
    session_id,
    player_id,
    input,
    response_handler
  ) {
    const request = {
      "player_team_id": player_team_id,
      "computer_team_id": computer_team_id,
      "scene_id": scene_id,
      "session_id": session_id,
      "player_id": player_id,
      "input": input
    }
    // Call the provided response handler when the LLM response is received
    this.setup_websocket(response_handler)
    this.wsQueue.push(JSON.stringify(request))
  }
}

export default SmartNPC