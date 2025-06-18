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

import { Application, Assets, Graphics } from 'pixi.js';
import OptionSelection from "./OptionSelection.js"
import Coach from "./Coach.js"
import Screen from "./Screen.js"
import SmartNPC from "./SmartNPC.js";

// Populate your information here!
// **************************************************************
const APIKEY = undefined // Key used to call Gemini
const APIURL = undefined // URL where your smart NPC REST endpoints are hosted. Used to retrieve and update team details.
const WSURL = undefined  // URL hosting the smart NPC websocket server that hydrates LLM prompts and streams back LLM responses.

// The client won't start up if you haven't populated your information
if (typeof APIKEY === 'undefined' ||
  typeof APIURL === 'undefined' ||
  typeof WSURL === 'undefined'
) {
  throw new Error("Unable to start without API key and backend endpoints")
}

let backendClient = new SmartNPC({
  apiKey: APIKEY,
  apiURL: APIURL,
  wsURL: WSURL,
})

// Name of the smart NPC game 'scene' that contains your prompt template. See
// the smart NPC documentation for details. 
const sceneId = "TACTICS_SELECTION_20250317_011"
// **************************************************************

// Header text for the windows displaying the player's available options.
const optionSelectionHeaderExamples = {
  "batting": "Swing time! Let's see some action, what's the call?",
  "pitching": "Trust your instincts! What's the perfect pitch here?"
}

// The backend stores and sends us only position abbreviations, which 
// we want to re-hydrate to display in the client UI.
const positionAbbreviations = {
  'C': "catcher",
  '1B': "first baseman",
  '2B': "second baseman",
  '3B': "third baseman",
  'SS': "shortstop",
  'LF': "left fielder",
  'CF': "center fielder",
  'RF': "right fielder",
  'DH': "designated hitter",
}

// Default roster stats format as received from the backend. Used as a table
// header when displaying the stats of players in the batting lineup.
const rosterColumns = ['Position', 'Player', 'Batting Hand', 'Avg', 'HR', 'RBI', 'Notes']

// Modify the roster header client-side to make the batting lineup table fit our UI
let rosterHeader = rosterColumns.filter((item) => { return item !== "Notes" })
rosterHeader = rosterHeader.map((item) => { return item == "Position" ? "Pos" : item })
rosterHeader = rosterHeader.map((item) => { return item == "Player" ? "Name" : item })
rosterHeader = rosterHeader.map((item) => { return item == "Batting Hand" ? "Hand" : item })

// Game assets need individual x, y, and scale properties, so store everything
// related to assets in this object and construct the pixi.js manifest bundle at
// run-time
const gameAssetProperties = {
  'title-screen': {
    'background': { src: '/images/imagen3/title/newtitle.png', x: 0, y: 0, scale: 1.0 },
  },
  'game-screen': {
    // field background
    'background': { src: '/images/imagen3/fields/03.png', x: 0, y: 0, scale: 1.0 },

    // red batters
    'suzuki': { src: '/images/imagen3/red/suzuki.png', x: 10, y: 40, scale: 0.8 },
    'ackley': { src: '/images/imagen3/red/ackley.png', x: -30, y: 30, scale: 0.9 },
    'montero': { src: '/images/imagen3/red/montero.png', x: 10, y: 40, scale: 0.9 },
    'smoak': { src: '/images/imagen3/red/smoak.png', x: 20, y: 60, scale: 0.9 },
    'carp': { src: '/images/imagen3/red/carp.png', x: 20, y: 20, scale: 0.9 },
    'seager': { src: '/images/imagen3/red/seager.png', x: 20, y: 60, scale: 0.75 },
    'saunders': { src: '/images/imagen3/red/saunders.png', x: 10, y: -100, scale: 1.0 },
    'wells': { src: '/images/imagen3/red/wells.png', x: 50, y: 60, scale: 0.75 },
    'ryan': { src: '/images/imagen3/red/ryan.png', x: 20, y: 40, scale: 0.9 },

    // red pitcher
    'nguyen': { src: '/images/imagen3/red/nguyen.png', x: 2000, y: 150, scale: 1.0 },

    // blue batters
    'trout': { src: '/images/imagen3/blue/trout.png', x: 10, y: 0, scale: 0.9 },
    'aybar': { src: '/images/imagen3/blue/aybar.png', x: 10, y: 100, scale: 0.8 },
    'pujols': { src: '/images/imagen3/blue/pujols.png', x: 10, y: 100, scale: 0.8 },
    'hunter': { src: '/images/imagen3/blue/hunter.png', x: 10, y: 60, scale: 0.8 },
    'trumbo': { src: '/images/imagen3/blue/trumbo.png', x: 10, y: 60, scale: 0.8 },
    'mathers': { src: '/images/imagen3/blue/mathers.png', x: 10, y: -5, scale: 0.8 },
    'kendrick': { src: '/images/imagen3/blue/kendrick.png', x: 10, y: 60, scale: 0.8 },
    'callaspo': { src: '/images/imagen3/blue/callaspo.png', x: 10, y: 20, scale: 0.8 },
    'iannetta': { src: '/images/imagen3/blue/iannetta.png', x: 10, y: 0, scale: 0.9 },

    // red pitcher
    'wilder': { src: '/images/imagen3/blue/wilder.png', x: 1800, y: 50, scale: 1.0 },

    // coach headshots
    'blue-coach': { src: '/images/imagen3/blue/coach.png', x: 0, y: 0, scale: 1.0 },
    'blue-coach-hl': { src: '/images/imagen3/blue/coach-hl.png', x: 0, y: 0, scale: 1.0 },
    'red-coach': { src: '/images/imagen3/red/coach.png', x: 0, y: 0, scale: 1.0 },
    'red-coach-hl': { src: '/images/imagen3/red/coach-hl.png', x: 0, y: 0, scale: 1.0 },

    // screen UI overlay
    'ui-away': { src: '/images/imagen3/ui/ui-away.png', x: 0, y: 0, scale: 1.0 },
    'ui-home': { src: '/images/imagen3/ui/ui-home.png', x: 0, y: 0, scale: 1.0 },
  }
}

// Make a pixi asset manifest https://pixijs.com/8.x/guides/components/assets#loading-multiple-assets
let manifest = { bundles: [] }
for (const [screenName, properties] of Object.entries(gameAssetProperties)) {
  let assets = []
  console.log(`"dynamically generating manifest for ${screenName}`)
  for (const [assetName, assetProperties] of Object.entries(properties)) {
    assets.push({ alias: assetName, src: assetProperties.src })
  }
  manifest.bundles.push({ name: screenName, assets: assets })
}

// Set up the player info 
let p1 = {
  location: "home",
  id: "JackBuser",
  optionSelection: undefined
}
// By default p2 is controlled by the computer 
let p2 = {
  location: "away",
  id: "Computer",
  optionSelection: undefined
}

// NYI - these are here to allow us to have two asymmetrical client views in the future.
p1.screen = document.querySelector(".game-container");
p2.screen = document.querySelector(".game-container");

// Demo doesn't allow players to select teams, so instead of reading this from
// player input, it is hardcoded:
// player 1 is the red home team
// player 2 is the blue away team
const playersByTeamID = { "red": p1, "blue": p2 }
const playersByTeamRole = { "home": p1, "away": p2 }

// Session Id and Player Id
// Generate random UUIDv4
const uuidv4 = () => "10000000-1000-4000-8000-100000000000".replace(/[018]/g, c =>
  (+c ^ crypto.getRandomValues(new Uint8Array(1))[0] & 15 >> +c / 4).toString(16)
);
const sessionId = uuidv4()

// Default players, in the same format as what we get from the LLM.
//
// These values are replaced by values received from the backend on startup, but
// are useful to have here so we can reference the format while programming the
// client.
let defaultPitchers = {
  "home": [{
    "name": "Michael Nguyen", "stats": {
      "this_season": { "GP": 16, "GS": 15, "CG": 3, "SHO": 3, "IP": 77.6, "H": 99, "R": 36, "ER": 31, "HR": 4, "BB": 44, "K": 91 },
      "career": { "GP": 176, "GS": 150, "CG": 9, "SHO": 12, "IP": 771.7, "H": 1062, "R": 361, "ER": 310, "HR": 34, "BB": 521, "K": 874 },
    },
  }],
  "away": [{
    "name": "Hank Wilder", "stats": {
      "this_season": { "GP": 16, "GS": 15, "CG": 3, "SHO": 3, "IP": 77.6, "H": 99, "R": 36, "ER": 31, "HR": 4, "BB": 44, "K": 91 },
      "career": { "GP": 176, "GS": 150, "CG": 9, "SHO": 12, "IP": 771.7, "H": 1062, "R": 361, "ER": 310, "HR": 34, "BB": 521, "K": 874 },
    },
  }]
}
let defaultRosters = {
  "home": [
    { "position": "CF", "name": "Ryuichi Suzuki", "hand": "Left", "avg": .315, "hr": 9, "rbi": 51, "notes": "High average, contact hitter, limited power." },
    { "position": "2B", "name": "Robert Ackley", "hand": "Left", "avg": .226, "hr": 12, "rbi": 50, "notes": "Some power, but struggled with consistency." },
    { "position": "C", "name": "Jon Montero", "hand": "Left", "avg": .260, "hr": 15, "rbi": 62, "notes": "Developing power hitter, still inconsistent." },
    { "position": "1B", "name": "Mark Smoak", "hand": "Both", "avg": .217, "hr": 19, "rbi": 51, "notes": "Switch-hitter, power potential, low average." },
    { "position": "DH", "name": "Joel Carp", "hand": "Left", "avg": .213, "hr": 5, "rbi": 18, "notes": "Limited at-bats, low batting average." },
    { "position": "3B", "name": "Richard Seager", "hand": "Left", "avg": .259, "hr": 20, "rbi": 86, "notes": "Good power for a middle infielder." },
    { "position": "RF", "name": "Brett Saunders", "hand": "Left", "avg": .247, "hr": 19, "rbi": 57, "notes": "Power and speed, high strikeout rate." },
    { "position": "LF", "name": "Paul Wells", "hand": "Right", "avg": .228, "hr": 10, "rbi": 36, "notes": "Power potential, but inconsistent contact overall." },
    { "position": "SS", "name": "James Ryan", "hand": "Right", "avg": .194, "hr": 3, "rbi": 31, "notes": "Very weak hitter, almost no power." },
  ],
  "away": [
    { "position": "CF", "name": "Grant Trout", "hand": "Right", "avg": .326, "hr": 30, "rbi": 83, "notes": "Exceptional rookie, speed and power combo." },
    { "position": "SS", "name": "Aris Aybar", "hand": "Both", "avg": .290, "hr": 8, "rbi": 45, "notes": "Switch-hitter, good contact, solid average." },
    { "position": "1B", "name": "Sandeep Pujols", "hand": "Right", "avg": .285, "hr": 30, "rbi": 105, "notes": "Still potent, but declining from peak." },
    { "position": "RF", "name": "Jaime Hunter", "hand": "Right", "avg": .313, "hr": 16, "rbi": 92, "notes": "Consistent hitter, good average and RBIs." },
    { "position": "DH", "name": "Francis Trumbo", "hand": "Right", "avg": .268, "hr": 32, "rbi": 95, "notes": "Big power, high strikeout, solid production." },
    { "position": "LF", "name": "Maurice Mathers", "hand": "Right", "avg": .230, "hr": 11, "rbi": 29, "notes": "Struggling veteran, low average, limited power." },
    { "position": "2B", "name": "Dre Kendrick", "hand": "Right", "avg": .287, "hr": 8, "rbi": 67, "notes": "Solid contact hitter, decent average." },
    { "position": "3B", "name": "Jose Callaspo", "hand": "Both", "avg": .252, "hr": 10, "rbi": 53, "notes": "Decent contact, switch-hitter, average power." },
    { "position": "C", "name": "Jesus Iannetta", "hand": "Right", "avg": .240, "hr": 9, "rbi": 26, "notes": "Some power, lower batting average overall." },
  ],
}
let teams = [
  { // default home team (player 1)
    "id": "red", // placeholder team name
    "roster": { "pitchers": defaultPitchers.home, "fielders": defaultRosters.home },
    "lineup": { "pitcher": defaultPitchers.home[0], "fielders": defaultRosters.home },
    "color": "red",
  },
  { // default away team (player 2)
    "id": "blue", // placeholder team name
    "roster": { "pitchers": defaultPitchers.away, "fielders": defaultRosters.away },
    "lineup": { "pitcher": defaultPitchers.away[0], "fielders": defaultRosters.away },
    "color": "blue",
  },
]

// Fetch the actual teams we will use for this run from the backend. 
// getTeams() returns teams in the format shown above.
console.log("getting teams from backend")
teams = backendClient.GetTeams("all", "", "")
console.log(`teams = ${JSON.stringify(teams)}`)

// Assign teams to players
for (const team of teams) {
  let id = team.id.toLowerCase()
  if (playersByTeamID.hasOwnProperty(id)) {
    playersByTeamID[id].team = team
    playersByTeamID[id].team.uiColor = id // TODO: add team color to the properties returned by the backend 
    console.log(`assigning team '${id}' to player.id '${playersByTeamID[id].id}'`)
  }
}

// Player info helper functions, to figure out which team is away or home, or
// batting or pitching
function battingTeam(halfInning) { return halfInning % 2 === 0 ? "away" : "home"; }
function pitchingTeam(halfInning) { return halfInning % 2 === 0 ? "home" : "away"; }
function battingTeamId(halfInning) { return battingTeam(halfInning) == "home" ? p1.team.id : p2.team.id }
function pitchingTeamId(halfInning) { return pitchingTeam(halfInning) == "home" ? p1.team.id : p2.team.id }
function role(player, halfInning) {
  // Home team is pitching in top and batting in bottom of innings.
  if (player.location == "home") { return halfInning % 2 === 0 ? "pitching" : "batting"; }
  // Away team is pitching in bottom and batting in top of innings.
  return halfInning % 2 === 0 ? "batting" : "pitching";
}

// Local vars to contain the DOM elements we need to manipulate
let gameCanvas = document.createElement("canvas");
let ctx = gameCanvas.getContext("2d");

// Set up the client browser app game canvas 'window' size
let width = 2560
let height = 1408

// Set canvas properties
gameCanvas.width = width;
gameCanvas.height = height;
ctx.scale(0.5, 0.5);
ctx.imageSmoothingEnabled = false;

// init pixi app
const app = new Application();
await app.init({ height: height, width: width });
p1.screen.appendChild(app.canvas);

// Background screen animation queue setup.
//
// This is a Global animation queue; the game can only handle one
// 'display task' at a time. Each animation has to be 'resolved' and removed
// from the queue (typically by having the Screen object resolve() event handler
// call the advanceAnimationQueue() function in this file) before the next
// animation will be displayed.
let currentScreen = "title-screen"
let screenAnimationQueue = []

// Display LLM tutorial coach?
let tutorialEnabled = true

// optionJSON is an array that holds all responses we've gotten from the LLM.
// Obviously this isn't how you'd do this in production but we want to keep
// it all around so we can audit/debug our prompts during the PoC.
// New entries are prepended using unshift() so that the 0 index is always
// the most recent LLM response to ease debugging.
let turnJSON = new Array()
// llmResponse is a temporary holding area for incoming llm reponses so we can asynchronously kick off 
// llm requests and process them as they arrive instead of blocking and waiting for them.
let llmResponse = new Array()

// TODO: encapsulate this instead of having it be a global var
// Array of every game state update we've used from the LLM
let gameStateUpdates = []
let currentState = calculateGameState()

// call the LLM to get all the data for the next turn.
function callLLM() {
  // The game frontend sends the current state to the backend, which handles 
  // the prompt templating to construct the final prompt it sends to the LLM. 
  console.log("calling LLM with current game state:" + JSON.stringify(currentState))
  // WebSocket
  backendClient.GetTacticsWS(
    p1.team.id,
    p2.team.id,
    sceneId,
    sessionId,
    p1.id,
    JSON.stringify({ "CURRENT_STATE": stringifyState(currentState) }),
    // Websocket response handler.
    (llm_response) => {
      console.log(`++ event_handler:${JSON.stringify(llm_response)}`)
      // Make sure the response is valid
      if (llm_response == {} || llm_response == "{}") {
        console.log(`llm response is empty, skip`)
      } else {
        // Push the response onto the llmResponse queue. This is processed once
        // per frame in the ticker main game loop.
        //llmResponse.push(llm_response.response)
        llmResponse.push(JSON.parse(llm_response.response))
      }
    }
  ) // End WebSocket
}

// NOTE: for now this only allows up to 9 innings!!
// Scoreboard is managed locally, and not sent to the LLM. 
let scoreboard = {
  away: ["away", 0, 0, 0, 0, 0, 0, 0, 0, 0],
  home: ["home", 0, 0, 0, 0, 0, 0, 0, 0, 0],
}
const scoreLegend = ["inning", 1, 2, 3, 4, 5, 6, 7, 8, 9]

// calculateGameState loops through every at-bat since the beginning of the game, and 
// re-calculates the current state. Obviously this isn't how you'd do this in production,
// but during debugging this allows us to manually re-write the at-bat results in the 
// debugger during development if necessary.
function calculateGameState() {

  // Beginning game state
  let state = {
    r1: false, // runner on first
    r2: false, // runner on second
    r3: false, // runner on third
    outs: 0,
    score: {
      home: 0,
      away: 0,
    },
    halfInning: 0, // 0-17, even are top of the inning, odds are bottom
    batter: { // current position in the batting order
      home: 0,
      away: 0,
    },
    pitcher: {
      home: 0,
      away: 0,
    },
    atBatCount: 0,
  }

  console.log("calculateGameState State 0000:" + JSON.stringify(state))
  // Apply every update since the beginning of the game
  for (let i = 0; i < gameStateUpdates.length; i++) {
    const update = gameStateUpdates[i]

    state.atBatCount++
    state.outs = update.outs

    if (state.outs > 2) {
      // No runs counted on the play that generates the last out of a (half) inning
      update.runs = 0

      // Clear bases
      update.r1 = false
      update.r2 = false
      update.r3 = false

      // Advance the (half) inning
      state.halfInning++
      state.outs = 0
      state.atBatCount = 0
    }

    console.log(`calculateGameState Turn ${String(i + 1).padStart(4, '0')}: ${JSON.stringify(update)}`)

    // Get offensive team
    let offensiveTeam = battingTeam(state.halfInning)

    // Update running total score
    state.score[offensiveTeam] += update.runs

    // Update the score for this half-inning (for the scoreboard display, not sent to the LLM)
    scoreboard[offensiveTeam][Math.floor(state.halfInning / 2) + 1] += update.runs

    // Go to next batter in the order
    state.batter[offensiveTeam] = (state.batter[offensiveTeam] + 1) % 9

    // Update bases
    state.r1 = update.r1
    state.r2 = update.r2
    state.r3 = update.r3

    console.log(`calculateGameState State ${String(i + 1).padStart(4, '0')}:${JSON.stringify(state)}`)
  }

  return state
}

// generateOptionSelection converts the LLM output into a list of options that
// can be displayed to the player.
function generateOptionSelections(oJSON, screen) {
  console.log(`** generateOptionSelections **`)
  console.log(oJSON)

  let optionSelections = {}
  for (const p of Object.values(playersByTeamRole)) { // Loop through all players.
    // Get current roles for each player ("batting" or "pitching"), changes every half-inning
    p.currentRole = role(p, currentState.halfInning)

    optionSelections[p.location] = {
      "screen": screen,
      "animation": "displayOptionSelection",
      "optionSelection": new OptionSelection({
        headerText: optionSelectionHeaderExamples[p.currentRole],
        recommendedOptionIndex: oJSON.recommendations[p.currentRole].index,
        teamColor: p.team.uiColor,
        teamRole: p.currentRole,
        options: (() => {
          const options = []

          // Add each option to the options array
          for (let i = 0; i < oJSON.tactics[p.currentRole].length; i++) {
            options.push({
              // Capitalize the role ("batting" -> "Batting", "pitching" -> "Pitching") for display
              title: `${p.currentRole[0].toUpperCase() + p.currentRole.slice(1)} Tactic ${i + 1}`,
              text: oJSON.tactics[p.currentRole][i],
              index: i,
            })
          }
          return options
        })(),

        // player selection is handled by this 'resolve' function once the player clicks 'accept'.
        resolve: (selection) => {
          console.log(`${p.location} team selected option ${selection.index}`)
          p.optionSelection = selection.index
        },
      })
    }
  }

  return optionSelections
}

// generateTutorialDisplay converts the LLM in-game tutorial recommendation into
// a text box to display to the player.
function generateCoachingDisplay(oJSON, screen) {
  console.log(`** generateCoachingDisplay **`)
  console.log(oJSON)
  let tutorials = {}
  for (const p of Object.values(playersByTeamRole)) { // Loop through all players.
    p.currentRole = role(p, currentState.halfInning)

    tutorials[p.location] = {
      "screen": screen,
      "animation": "displayGeminiCoach",
      "coach": new Coach({
        title: "Head Coach",
        recommendation: oJSON.recommendations[p.currentRole],
        teamColor: p.team.uiColor,
        teamRole: p.currentRole,
        imgSrc: `/images/imagen3/${p.team.uiColor}/coach.png`,
        logoSrc: '/images/logos/Gemini_Logo_Lockup_Gradient.png',
        resolve: () => (
          // Take action after the player clicks 'accept' on the coaching dialog. 
          // For PoC, just log instead.
          console.log("resolving coaching dialog box")
        ),
      }),
    }
  }
  return tutorials
}

// Initialize background animation queue.
screenAnimationQueue.unshift(
  { "screen": "title-screen", "animation": "fadeIn" },
  { "screen": "title-screen", "animation": "fadeOut" },
  { "screen": "game-screen", "animation": "fadeIn" },
)

// Animation helper function
const advanceAnimationQueue = () => {
  console.log("advancing background animation")
  console.log(JSON.stringify(screenAnimationQueue))
  screenAnimationQueue.shift()
}

// load & init assets using pixi.js
await Assets.init({ manifest })
await Assets.backgroundLoadBundle(Array.from(Object.keys(gameAssetProperties)))
const gameScreens = new Map()

// Set up each of the screens, and the background images for those screens.
for (const screenName of Array.from(Object.keys(gameAssetProperties))) {
  // load the assets in the background
  console.log(`loading asset bundle ${screenName}`)
  await Assets.backgroundLoadBundle(screenName)

  // In general, all screens just resolve each item in their animation queue by
  // advancing the animation state, and moving on to the next thing to display
  let resolutionFunction = advanceAnimationQueue
  if (screenName === "title-screen") {
    resolutionFunction = () => {
      if (screenAnimationQueue[0].animation === "fadeOut") {
        // Title screen needs to do additional work when resolving its fadeOut
        // animation: it has to initialize the game UI
        initUI()
        updateUI()
      }
      advanceAnimationQueue()
    }
  }

  // store a reference to this screen (by name) for later use
  gameScreens.set(screenName, new Screen({
    assetBundle: await Assets.loadBundle(screenName),
    backgroundAssetAlias: "background",
    stage: app.stage,
    gameDiv: p1.screen,
    initialAlpha: 0.0, // All screens have to be manually faded in
    // callback the screen can use to pause background animations while waiting on player input
    buttonIdle: () => { screenAnimationQueue[0] = { "screen": currentScreen, "animation": "idle" } },
    // callback used when screen fade-in and fade-out complete that moves on to the next background animation. 
    resolve: resolutionFunction,
  }))

  gameScreens.get(screenName).addTo(app.stage)
}

// Create a table. Used to display the scoreboard and batting lineup.
function createTable(tableClass, header, data, highlightRow) {
  const table = document.createElement('table');
  table.classList.add(tableClass)
  const thead = document.createElement('thead');
  const tbody = document.createElement('tbody');

  // --- Create Header Row ---
  if (header) {
    const headerRow = document.createElement('tr');
    if (highlightRow.display)
      header.unshift(highlightRow.inactive) // prepend a column for the selection cursor

    header.forEach((headerText, index) => {
      const th = document.createElement('th');
      const span = document.createElement('span');

      // Give every cell the CSS class of this column. The CSS file can then
      // make a separate class with the given column name to give it a different
      // style. 
      const cellClass = String(headerText).trim().toLowerCase() === "" ? "empty" : String(headerText).trim().toLowerCase()
      th.classList.add(cellClass)
      span.textContent = headerText;
      th.appendChild(span);
      headerRow.appendChild(th);
    });
    thead.appendChild(headerRow);
    table.appendChild(thead);
  }
  // --- Create Table Body ---
  data.forEach((rowData, rowNum) => {
    const tr = document.createElement('tr');

    // add a cursor for the current batter 
    if (highlightRow.display && rowNum === highlightRow.rowIndex) { rowData.unshift(highlightRow.active) }
    else if (highlightRow.display) { rowData.unshift(highlightRow.inactive) }

    rowData.forEach((cellData, index) => {
      const td = document.createElement('td');

      let cellClass = "empty"
      if (header)
        // Give every cell the CSS class of this column if the column has a name
        // (i.e. a header exists). The CSS file can then make a separate class
        // with the given column name to give it a different style. 
        cellClass = String(header[index]).trim().toLowerCase() === "" ? "empty" : String(header[index]).trim().toLowerCase()
      td.classList.add(cellClass)
      td.textContent = cellData;
      tr.appendChild(td);
    });

    tbody.appendChild(tr);
  });
  table.appendChild(tbody);

  return table
}

// Create vars to hold the tables to display later
let battingLineupTable = undefined
let outsTable = undefined
let pStatsTable = undefined
let bStatsTable = undefined
let scoreboardTable = undefined

// We can leverage existing update lineup mechanism to store Player and computer
// lineup in the backend.
// The backend does not validate lineup / roster.
for (const p of Object.values(playersByTeamRole)) { // Loop through all players.
  console.log(`updating player team lineup:\n${sessionId} | ${p.id} | ${p.team.id}`)
  console.log(JSON.stringify(p.team.lineup))
  backendClient.UpdateLineup(p.team.id,
    sessionId,
    p.id,
    p.team.lineup
  )
}

// critical bits initialized, ready to make the first at-bat turn LLM call.
// This is what kicks the whole game off.
callLLM()

const batterPosition = document.createElement('div')
const batterName = document.createElement('div')
const pitcherName = document.createElement('div')
const pitcherTitle = document.createElement('div')
const playerNameBar = document.createElement('div');
const battingOrderRollup = document.createElement('div')
const battingOrderTitle = document.createElement('div')
const battingOrderDropdownArrow = document.createElement('div')

// Init sprites
let currentlyDisplayedSprites = {
  "batter": undefined,  // Batter portrait
  "pitcher": undefined, // Pitcher portrait
  "ui": undefined,      // UI overlay 
  "runners": {
    // The LLM results abbreviates first, second, and third base runners
    // as r1, r2, r3
    "r1": undefined,
    "r2": undefined,
    "r3": undefined,
  }
}

// Create graphics objects for the runner UI
const runnerUICircleSize = 20
let runnerUI = {
  "screenCoords": {
    "r1": { x: 1400, y: 1250 },
    "r2": { x: 1260, y: 1155 },
    "r3": { x: 1160, y: 1290 },
  },
}

// Create graphics, store in the runnerUI object under the key of the team's color
for (const [role, player] of Object.entries(playersByTeamRole)) {
  const uiColor = player.team.uiColor
  for (const runnerKey of Object.keys(runnerUI.screenCoords)) {
    if (!runnerUI[uiColor])
      runnerUI[uiColor] = {}
    runnerUI[uiColor][runnerKey] = new Graphics()
    runnerUI[uiColor][runnerKey].context.circle(
      runnerUI.screenCoords[runnerKey].x,
      runnerUI.screenCoords[runnerKey].y,
      runnerUICircleSize).fill(uiColor)
  }
}

function initUI() {
  // Continue UI init while waiting for LLM response.
  // Init top bar UI 
  // Player name bar (top bar of the main game UI)
  batterPosition.classList.add("playerNameBar")
  batterPosition.classList.add("batterPosition")
  batterName.classList.add("playerNameBar")
  batterName.classList.add("batterName")

  // Default batter name. Should never see this name, unless there's a problem somewhere 
  batterName.textContent = "Horus Wilder"
  pitcherName.classList.add("playerNameBar")
  pitcherName.classList.add("pitcherName")

  // Default pitcher name.Should never see this name, unless there's a problem somewhere
  pitcherName.textContent = "Huck Green"
  pitcherTitle.classList.add("playerNameBar")
  pitcherTitle.classList.add("pitcher")

  playerNameBar.appendChild(batterPosition)
  playerNameBar.appendChild(batterName)
  playerNameBar.appendChild(pitcherName)
  playerNameBar.appendChild(pitcherTitle)
  document.querySelector(".game-container").appendChild(playerNameBar)

  // Create batting order display, hidden by default
  battingOrderTitle.classList.add("battingOrderUI")
  battingOrderTitle.classList.add("greyTransparentBG")
  battingOrderTitle.textContent = "Batting Lineup"
  battingOrderRollup.appendChild(battingOrderTitle)

  battingOrderDropdownArrow.classList.add("battingOrderDropdown")
  battingOrderDropdownArrow.classList.add("arrowClosed")
  battingOrderDropdownArrow.textContent = "➤"
  battingOrderRollup.appendChild(battingOrderDropdownArrow)

  battingOrderRollup.addEventListener('click', () => {
    if (battingOrderDropdownArrow.classList.contains("arrowClosed")) {
      battingOrderDropdownArrow.classList.replace("arrowClosed", "arrowOpen")
      battingOrderTitle.classList.add("battingOrderOpen")
      document.querySelector(".game-container").appendChild(battingLineupTable)
    }
    else if (battingOrderDropdownArrow.classList.contains("arrowOpen")) {
      battingOrderDropdownArrow.classList.replace("arrowOpen", "arrowClosed")
      battingOrderTitle.classList.remove("battingOrderOpen")
      document.querySelector(".game-container").removeChild(battingLineupTable)
    }
  })
  document.querySelector(".game-container").appendChild(battingOrderRollup)
}

function updateUI() {
  console.log("<<<<<<<<<<< updating UI")

  // Update lineup arrow
  let currentRoster = []
  for (const row of defaultRosters[battingTeam(currentState.halfInning)])
    currentRoster.push([row.position, row.name.split(" ")[1], row.hand, row.avg, row.hr, row.rbi]) // Omit the 'notes' field, and only use the family name
  battingLineupTable = createTable("battingOrder", rosterHeader, currentRoster,
    { display: true, active: "➤", inactive: " ", rowIndex: currentState.batter[battingTeam(currentState.halfInning)] }); // Use the away roster

  // Update scoreboard
  try {
    document.querySelector(".game-container").removeChild(scoreboardTable)
  } catch (error) {
    console.log("No scoreboard display to remove from DOM")
  }
  scoreboardTable = createTable("scoreboard", scoreLegend, [scoreboard.away, scoreboard.home], { display: false })
  document.querySelector(".game-container").appendChild(scoreboardTable)

  // Update outs 
  try {
    document.querySelector(".game-container").removeChild(outsTable)
  } catch (error) {
    console.log("No outs display to remove from DOM")
  }
  outsTable = createTable("state", undefined, [["OUTS", currentState.outs]], { display: false })
  document.querySelector(".game-container").appendChild(outsTable)

  // Update Pitcher stats
  try {
    document.querySelector(".game-container").removeChild(pStatsTable)
  } catch (error) {
    console.log("No pitcher stats display to remove from DOM")
  }
  const pStats = playersByTeamRole[pitchingTeam(currentState.halfInning)].team.lineup.pitcher.stats.this_season
  pStatsTable = createTable(
    "pitcherStats",
    undefined,
    [
      ["ERA", ((pStats.ER / pStats.IP) * 9).toFixed(2)],
      ["STRIKEOUTS", pStats.K],
      ["WHIP", ((pStats.H + pStats.BB) / pStats.IP).toFixed(2)],
    ],
    { display: false })
  document.querySelector(".game-container").appendChild(pStatsTable)

  // Update Batter stats
  try {
    document.querySelector(".game-container").removeChild(bStatsTable)
  } catch (error) {
    console.log("No batter stats display to remove from DOM")
  }
  const bStats = playersByTeamRole[battingTeam(currentState.halfInning)].team.lineup.fielders[currentState.batter[battingTeam(currentState.halfInning)]]
  bStatsTable = createTable(
    "batterStats",
    undefined,
    [
      ["AVG", bStats.avg],
      ["HR", bStats.hr],
      ["RBI", bStats.rbi],
    ],
    { display: false })
  document.querySelector(".game-container").appendChild(bStatsTable)

  // Update player name & position & batter image
  // Player name bar (top bar of the main game UI)
  batterPosition.textContent = positionAbbreviations[playersByTeamRole[battingTeam(currentState.halfInning)].team.lineup.fielders[currentState.batter[battingTeam(currentState.halfInning)]].position]
  batterName.textContent = playersByTeamRole[battingTeam(currentState.halfInning)].team.lineup.fielders[currentState.batter[battingTeam(currentState.halfInning)]].name
  pitcherTitle.textContent = "starting pitcher"
  pitcherName.textContent = playersByTeamRole[pitchingTeam(currentState.halfInning)].team.lineup.pitcher.name

  // Update batter image
  if (currentlyDisplayedSprites["batter"])
    gameScreens.get("game-screen").removeChild(currentlyDisplayedSprites["batter"])
  currentlyDisplayedSprites["batter"] = batterName.textContent.split(" ")[1].toLowerCase() // sprites are named after the player's last name
  console.log(`displaying ${currentlyDisplayedSprites["batter"]} sprite`)
  gameScreens.get("game-screen").addChildSprite(
    currentlyDisplayedSprites["batter"],
    gameAssetProperties["game-screen"][currentlyDisplayedSprites["batter"]],
    false,
  )

  // Update pitcher image
  if (currentlyDisplayedSprites["pitcher"])
    gameScreens.get("game-screen").removeChild(currentlyDisplayedSprites["pitcher"])
  currentlyDisplayedSprites["pitcher"] = pitcherName.textContent.split(" ")[1].toLowerCase() // sprites are named after the player's last name
  console.log(`displaying ${currentlyDisplayedSprites["pitcher"]} sprite`)
  gameScreens.get("game-screen").addChildSprite(
    currentlyDisplayedSprites["pitcher"],
    gameAssetProperties["game-screen"][currentlyDisplayedSprites["pitcher"]],
    false,
  )

  // Update UI
  if (currentlyDisplayedSprites["ui"])
    gameScreens.get("game-screen").removeChild(currentlyDisplayedSprites["ui"], true)
  currentlyDisplayedSprites["ui"] = `ui-${battingTeam(currentState.halfInning)}`
  console.log(`displaying ${currentlyDisplayedSprites["ui"]} sprite`)
  gameScreens.get("game-screen").addChildSprite(
    currentlyDisplayedSprites["ui"],
    gameAssetProperties["game-screen"][currentlyDisplayedSprites["ui"]],
    true,
  )

  // Update on-base HUD
  // The screen object internally tracks runner UI graphics under names like
  // "blue-r1" and "red-r3". These graphics are just simple colored circles.
  // Get the team color for batting team
  const runnerColor = playersByTeamRole[battingTeam(currentState.halfInning)].team.uiColor
  // Get the team color for pitching team
  const inactiveRunnerColor = playersByTeamRole[pitchingTeam(currentState.halfInning)].team.uiColor
  console.log(`><>< starting currentlyDisplayedSprites["runners"] = ${JSON.stringify(currentlyDisplayedSprites["runners"])}`)

  for (const [runnerKey, runnerGraphic] of Object.entries(currentlyDisplayedSprites["runners"])) {
    // Try to remove the pitching team runner graphics.  Does nothing if they don't exist.
    if (runnerGraphic && runnerGraphic.startsWith(inactiveRunnerColor)) {
      gameScreens.get("game-screen").removeChild(`${inactiveRunnerColor}-${runnerKey}`, true)
      currentlyDisplayedSprites["runners"][runnerKey] = undefined
    }
    // Check if we need to display a runner here.
    if (currentState[runnerKey]) {
      currentlyDisplayedSprites["runners"][runnerKey] = `${runnerColor}-${runnerKey}`
      console.log(`displaying ${runnerKey} runner ui element`)
      gameScreens.get("game-screen").addChildShape(
        runnerUI[runnerColor][runnerKey],
        `${runnerColor}-${runnerKey}`
      )
      // If we're currently displaying a runner on this base but we shouldn't be anymore
      // (they are out or have advanced bases)
    } else if (runnerGraphic) {
      gameScreens.get("game-screen").removeChild(`${runnerColor}-${runnerKey}`, true)
      currentlyDisplayedSprites["runners"][runnerKey] = undefined
    }
  }
}

// -----------------------------------------------------------------------------------
// Main Animation Loop
let outcomeDisplay = document.createElement("div")
outcomeDisplay.classList.add("fontDefaults")
outcomeDisplay.classList.add("outcome")

app.ticker.add((ticker) => {
  if (!(0 in screenAnimationQueue)) {
    console.log("unhandled animation state")
    screenAnimationQueue.unshift({ "screen": currentScreen, "animation": "idle" })
  } else {
    currentScreen = screenAnimationQueue[0].screen
    console.log(screenAnimationQueue[0].screen + ":" + screenAnimationQueue[0].animation)
  }

  // Call update for the current screen, and pass it the current timestamp and
  // what animation it is supposed to be doing right now
  gameScreens.get(screenAnimationQueue[0].screen).update(ticker.deltaTime, screenAnimationQueue[0])

  // process outcome, now that all players have completed their option selections
  if ((() => {
    for (const p of Object.values(playersByTeamRole)) {
      // If any player hasn't yet made their selection, then can't proceed
      if (p.optionSelection === undefined) { return false }
    }
    // Check if turnJSON is an array with at least one element,
    // and if that element has a non-empty 'outcomes' array.
    if (
      turnJSON &&
      turnJSON.length > 0 &&
      turnJSON[0].outcomes &&
      turnJSON[0].outcomes.length > 0
    ) { return false }
    // If all players have selected options, proceed
    return true
  }
  )()) {
    const outcomeIndex = (() => {
      let selectionIndexArray = []
      // We want to always create the key using the pitching team first and the
      // batting team second, as this is part of the LLM prompt.
      for (const p of [playersByTeamRole[pitchingTeam(currentState.halfInning)], playersByTeamRole[battingTeam(currentState.halfInning)]]) {
        selectionIndexArray.push(p.optionSelection) // Retrieve outcome for this player
        p.optionSelection = undefined // Reset option Selections
      }

      // the key for the outcome object is the index of each player
      // concatinated by periods. This is a bit frail but this is just a PoC.
      return selectionIndexArray.join(".")
    })()

    // Advance out of Idle animation state
    screenAnimationQueue.push({ "screen": "game-screen", "animation": "fadeOut" })
    advanceAnimationQueue()

    // Display the outcomes
    console.log(`+++ selections complete, outcome is ${JSON.stringify(turnJSON[0].outcomes[outcomeIndex])}`)
    const update = turnJSON[0].outcomes[outcomeIndex]
    outcomeDisplay.textContent = update.outcome
    document.querySelector(".game-container").appendChild(outcomeDisplay)

    // Add the game state outcome based on the player tactics to the game state update array 
    gameStateUpdates.push(update.game_state)
    // ... and then get the latest game state
    currentState = calculateGameState()
    // 'dirty' animation state flags the UI as needing an update, causing
    // updateUI() to get called.
    screenAnimationQueue.push({ "screen": "game-screen", "animation": "dirty" })

    // Start the next turn
    callLLM()
  }

  // Update screen UI if the UI is flagged as 'dirty'
  if ((screenAnimationQueue.length > 0) &&
    (screenAnimationQueue[0].hasOwnProperty("animation")) &&
    (screenAnimationQueue[0].animation == "dirty")) {
    updateUI()
    screenAnimationQueue.push({ "screen": "game-screen", "animation": "fadeIn" })
    advanceAnimationQueue()
  }

  // Process incoming LLM responses when idling
  if ((screenAnimationQueue.length > 0) &&
    (screenAnimationQueue[0].hasOwnProperty("animation")) &&
    (screenAnimationQueue[0].animation == "idle")) {
    if (llmResponse.length > 0) {

      // Each llm response is only part of the JSON we need to take a full turn.
      // Add this response to previous reponses as long as it contains portions of
      // this turn's JSON that we've not received yet.
      //
      // NOTE: This is not particularly robust if the llm responses somehow came
      // back incomplete we could end up with part of one turn's JSON being added
      // to an adjacent turn.  We've not seen that yet so haven't written code to
      // mitigate it.
      const latestLLMResponse = llmResponse.shift()
      for (const [key, value] of Object.entries(latestLLMResponse)) {
        // See if the latest turn already got an llm reponse of this type. If so,
        // this current llm response is for a new turn 
        if (turnJSON.length == 0 || (turnJSON[0].hasOwnProperty(key) && turnJSON[0][key]))
          turnJSON.unshift({ "processed": false }) // Initialize an empty turn that hasn't been processed
        turnJSON[0][key] = value
      }
      console.log(`   tactics         = ${(turnJSON[0].tactics !== undefined ? "true" : "FALSE")} 
   recommendations = ${(turnJSON[0].recommendations !== undefined ? "true" : "FALSE")} 
   outcomes        = ${(turnJSON[0].outcomes !== undefined ? "true" : "FALSE")} 
          ${JSON.stringify(turnJSON[0])}`)

      if (turnJSON[0].tactics !== undefined &&
        turnJSON[0].recommendations !== undefined &&
        (!turnJSON[0].processed)) {
        try {
          document.querySelector(".game-container").removeChild(outcomeDisplay)
        } catch (error) {
          console.log("ERROR trying to remove the outcome display box")
        }
        turnJSON[0].processed = true // Set processed flag so we don't re-process this turn in the future.
        let tutorials = undefined
        if (tutorialEnabled) // Skip tutorial if it's not enabled 
          // Process the LLM response to make a coaching display box for each
          // player, where they can see the gemini coach's recommended tactic
          // for this turn.
          tutorials = generateCoachingDisplay(turnJSON[0], "game-screen")

        // Process the LLM reponse to make an 'option selection' box for each
        // player, where they can choose their tactics for this turn.
        const optionSelections = generateOptionSelections(turnJSON[0], "game-screen")
        for (const p of Object.values(playersByTeamRole)) { // Loop through all players.
          if (tutorialEnabled && tutorials)
            screenAnimationQueue.push(tutorials[p.location])
          screenAnimationQueue.push(optionSelections[p.location])
        }
        // Added new screen animations to display; advance past idle state and start displaying them.
        advanceAnimationQueue()
      }
    }
  }
})
// -----------------------------------------------------------------------------------

// The LLM prompt needs a string describing the current state of the game, this function is used to 
// construct that string. It is not always a grammatically correct English sentence, but the LLM doesn't
// seem to have any issues related to this, it creates correct output anyway.
function stringifyState(state) {

  let offensiveTeam = battingTeam(state.halfInning)
  let defensiveTeam = pitchingTeam(state.halfInning)
  let half = state.halfInning % 2 !== 0 ? "bottom" : "top";
  let inning = Math.floor(state.halfInning / 2) + 1
  let batter = positionAbbreviations[playersByTeamRole[offensiveTeam].team.lineup.fielders[state.batter[offensiveTeam]].position]
  // -- Michael 20250314 --
  // let stateString = `The ${batter} on the ${offensiveTeam} team is batting in the `
  let stateString = `${playersByTeamRole[offensiveTeam].team.lineup.fielders[state.batter[offensiveTeam]].name} on the ${battingTeamId(state.halfInning)} team is batting.`
  stateString = stateString + "\n" + `${playersByTeamRole[defensiveTeam].team.lineup.pitcher.name} on the ${pitchingTeamId(state.halfInning)} team is pitching `
  // -- End 20250314 --
  stateString += `${half} of the ${inning} inning, with ${state.outs} outs and `

  const baseRunners = [];
  if (state.r1) baseRunners.push("first");
  if (state.r2) baseRunners.push("second");
  if (state.r3) baseRunners.push("third");
  if (baseRunners.length === 0) { stateString += "no runners on base. "; }
  else { stateString += "runners on " + baseRunners.join(", ") + ". "; }

  stateString += `The ${offensiveTeam} team has ${state.score[offensiveTeam]} runs, and `
  stateString += `The ${defensiveTeam} has ${state.score[defensiveTeam]}.`
  return stateString
}
