-- Copyright 2025 Google LLC
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

delete from smartnpc.teams;

INSERT INTO smartnpc.teams(
    team_id,
    team_name,
    team_year,
    description,
    roster,
    default_lineup
)
VALUES (
    'Red',
    'Red',
    2025,
    'Known for their aggressive batting style and powerful offense. Hailing from the sunny shores, the Coastal Comets bring a dynamic blend of speed and power to the diamond.',
    '{
  "pitchers":[{
    "name": "Michael Nguyen",
    "stats": {
      "this_season": {
        "GP": 16,
        "GS": 15,
        "CG": 3,
        "SHO": 3,
        "IP": 77.6,
        "H": 99,
        "R": 36,
        "ER": 31,
        "HR": 4,
        "BB": 44,
        "K": 91
      },
      "career": {
        "GP": 176,
        "GS": 150,
        "CG": 9,
        "SHO": 12,
        "IP": 771.7,
        "H": 1062,
        "R": 361,
        "ER": 310,
        "HR": 34,
        "BB": 521,
        "K": 874
      }
    }
  }],
  "fielders": [
    {
      "position": "CF",
      "name": "Ryuichi Suzuki",
      "hand": "Left",
      "avg": 0.315,
      "hr": 9,
      "rbi": 51,
      "notes": "High average, contact hitter, limited power."
    },
    {
      "position": "2B",
      "name": "Robert Ackley",
      "hand": "Left",
      "avg": 0.226,
      "hr": 12,
      "rbi": 50,
      "notes": "Some power, but struggled with consistency."
    },
    {
      "position": "C",
      "name": "Jon Montero",
      "hand": "Left",
      "avg": 0.26,
      "hr": 15,
      "rbi": 62,
      "notes": "Developing power hitter, still inconsistent."
    },
    {
      "position": "1B",
      "name": "Mark Smoak",
      "hand": "Both",
      "avg": 0.217,
      "hr": 19,
      "rbi": 51,
      "notes": "Switch-hitter, power potential, low average."
    },
    {
      "position": "DH",
      "name": "Joel Carp",
      "hand": "Left",
      "avg": 0.213,
      "hr": 5,
      "rbi": 18,
      "notes": "Limited at-bats, low batting average."
    },
    {
      "position": "3B",
      "name": "Richard Seager",
      "hand": "Left",
      "avg": 0.259,
      "hr": 20,
      "rbi": 86,
      "notes": "Good power for a middle infielder."
    },
    {
      "position": "RF",
      "name": "Brett Saunders",
      "hand": "Left",
      "avg": 0.247,
      "hr": 19,
      "rbi": 57,
      "notes": "Power and speed, high strikeout rate."
    },
    {
      "position": "LF",
      "name": "Paul Wells",
      "hand": "Right",
      "avg": 0.228,
      "hr": 10,
      "rbi": 36,
      "notes": "Power potential, but inconsistent contact overall."
    },
    {
      "position": "SS",
      "name": "James Ryan",
      "hand": "Right",
      "avg": 0.194,
      "hr": 3,
      "rbi": 31,
      "notes": "Very weak hitter, almost no power."
    }
  ]
}',
    '{
  "pitcher": {
    "name": "Michael Nguyen",
    "stats": {
      "this_season": {
        "GP": 16,
        "GS": 15,
        "CG": 3,
        "SHO": 3,
        "IP": 77.6,
        "H": 99,
        "R": 36,
        "ER": 31,
        "HR": 4,
        "BB": 44,
        "K": 91
      },
      "career": {
        "GP": 176,
        "GS": 150,
        "CG": 9,
        "SHO": 12,
        "IP": 771.7,
        "H": 1062,
        "R": 361,
        "ER": 310,
        "HR": 34,
        "BB": 521,
        "K": 874
      }
    }
  },
  "fielders": [
    {
      "position": "CF",
      "name": "Ryuichi Suzuki",
      "hand": "Left",
      "avg": 0.315,
      "hr": 9,
      "rbi": 51,
      "notes": "High average, contact hitter, limited power."
    },
    {
      "position": "2B",
      "name": "Robert Ackley",
      "hand": "Left",
      "avg": 0.226,
      "hr": 12,
      "rbi": 50,
      "notes": "Some power, but struggled with consistency."
    },
    {
      "position": "C",
      "name": "Jon Montero",
      "hand": "Left",
      "avg": 0.26,
      "hr": 15,
      "rbi": 62,
      "notes": "Developing power hitter, still inconsistent."
    },
    {
      "position": "1B",
      "name": "Mark Smoak",
      "hand": "Both",
      "avg": 0.217,
      "hr": 19,
      "rbi": 51,
      "notes": "Switch-hitter, power potential, low average."
    },
    {
      "position": "DH",
      "name": "Joel Carp",
      "hand": "Left",
      "avg": 0.213,
      "hr": 5,
      "rbi": 18,
      "notes": "Limited at-bats, low batting average."
    },
    {
      "position": "3B",
      "name": "Richard Seager",
      "hand": "Left",
      "avg": 0.259,
      "hr": 20,
      "rbi": 86,
      "notes": "Good power for a middle infielder."
    },
    {
      "position": "RF",
      "name": "Brett Saunders",
      "hand": "Left",
      "avg": 0.247,
      "hr": 19,
      "rbi": 57,
      "notes": "Power and speed, high strikeout rate."
    },
    {
      "position": "LF",
      "name": "Paul Wells",
      "hand": "Right",
      "avg": 0.228,
      "hr": 10,
      "rbi": 36,
      "notes": "Power potential, but inconsistent contact overall."
    },
    {
      "position": "SS",
      "name": "James Ryan",
      "hand": "Right",
      "avg": 0.194,
      "hr": 3,
      "rbi": 31,
      "notes": "Very weak hitter, almost no power."
    }
  ]
}'
);

INSERT INTO smartnpc.teams(
    team_id,
    team_name,
    team_year,
    description,
    roster,
    default_lineup
)
VALUES (
    'Blue',
    'Blue',
    2025,
    'A team known for its strong pitching and solid defensive play. Forged in the heartland, the Ironclad Armadillos are a team built on grit and resilience.',
    '{
  "pitchers": [{
    "name": "Hank Wilder",
    "stats": {
      "this_season": {
        "GP": 16,
        "GS": 15,
        "CG": 3,
        "SHO": 3,
        "IP": 77.6,
        "H": 99,
        "R": 36,
        "ER": 31,
        "HR": 4,
        "BB": 44,
        "K": 91
      },
      "career": {
        "GP": 176,
        "GS": 150,
        "CG": 9,
        "SHO": 12,
        "IP": 771.7,
        "H": 1062,
        "R": 361,
        "ER": 310,
        "HR": 34,
        "BB": 521,
        "K": 874
      }
    }
  }],
  "fielders": [
    {
      "position": "CF",
      "name": "Grant Trout",
      "hand": "Right",
      "avg": 0.326,
      "hr": 30,
      "rbi": 83,
      "notes": "Exceptional rookie, speed and power combo."
    },
    {
      "position": "SS",
      "name": "Aris Aybar",
      "hand": "Both",
      "avg": 0.29,
      "hr": 8,
      "rbi": 45,
      "notes": "Switch-hitter, good contact, solid average."
    },
    {
      "position": "1B",
      "name": "Sandeep Pujols",
      "hand": "Right",
      "avg": 0.285,
      "hr": 30,
      "rbi": 105,
      "notes": "Still potent, but declining from peak."
    },
    {
      "position": "RF",
      "name": "Jaime Hunter",
      "hand": "Right",
      "avg": 0.313,
      "hr": 16,
      "rbi": 92,
      "notes": "Consistent hitter, good average and RBIs."
    },
    {
      "position": "DH",
      "name": "Francis Trumbo",
      "hand": "Right",
      "avg": 0.268,
      "hr": 32,
      "rbi": 95,
      "notes": "Big power, high strikeout, solid production."
    },
    {
      "position": "LF",
      "name": "Maurice Mathers",
      "hand": "Right",
      "avg": 0.23,
      "hr": 11,
      "rbi": 29,
      "notes": "Struggling veteran, low average, limited power."
    },
    {
      "position": "2B",
      "name": "Dre Kendrick",
      "hand": "Right",
      "avg": 0.287,
      "hr": 8,
      "rbi": 67,
      "notes": "Solid contact hitter, decent average."
    },
    {
      "position": "3B",
      "name": "Jose Callaspo",
      "hand": "Both",
      "avg": 0.252,
      "hr": 10,
      "rbi": 53,
      "notes": "Decent contact, switch-hitter, average power."
    },
    {
      "position": "C",
      "name": "Jesus Iannetta",
      "hand": "Right",
      "avg": 0.24,
      "hr": 9,
      "rbi": 26,
      "notes": "Some power, lower batting average overall."
    }
  ]
}',
    '{
  "pitcher": {
    "name": "Hank Wilder",
    "stats": {
      "this_season": {
        "GP": 16,
        "GS": 15,
        "CG": 3,
        "SHO": 3,
        "IP": 77.6,
        "H": 99,
        "R": 36,
        "ER": 31,
        "HR": 4,
        "BB": 44,
        "K": 91
      },
      "career": {
        "GP": 176,
        "GS": 150,
        "CG": 9,
        "SHO": 12,
        "IP": 771.7,
        "H": 1062,
        "R": 361,
        "ER": 310,
        "HR": 34,
        "BB": 521,
        "K": 874
      }
    }
  },
  "fielders": [
    {
      "position": "CF",
      "name": "Grant Trout",
      "hand": "Right",
      "avg": 0.326,
      "hr": 30,
      "rbi": 83,
      "notes": "Exceptional rookie, speed and power combo."
    },
    {
      "position": "SS",
      "name": "Aris Aybar",
      "hand": "Both",
      "avg": 0.29,
      "hr": 8,
      "rbi": 45,
      "notes": "Switch-hitter, good contact, solid average."
    },
    {
      "position": "1B",
      "name": "Sandeep Pujols",
      "hand": "Right",
      "avg": 0.285,
      "hr": 30,
      "rbi": 105,
      "notes": "Still potent, but declining from peak."
    },
    {
      "position": "RF",
      "name": "Jaime Hunter",
      "hand": "Right",
      "avg": 0.313,
      "hr": 16,
      "rbi": 92,
      "notes": "Consistent hitter, good average and RBIs."
    },
    {
      "position": "DH",
      "name": "Francis Trumbo",
      "hand": "Right",
      "avg": 0.268,
      "hr": 32,
      "rbi": 95,
      "notes": "Big power, high strikeout, solid production."
    },
    {
      "position": "LF",
      "name": "Maurice Mathers",
      "hand": "Right",
      "avg": 0.23,
      "hr": 11,
      "rbi": 29,
      "notes": "Struggling veteran, low average, limited power."
    },
    {
      "position": "2B",
      "name": "Dre Kendrick",
      "hand": "Right",
      "avg": 0.287,
      "hr": 8,
      "rbi": 67,
      "notes": "Solid contact hitter, decent average."
    },
    {
      "position": "3B",
      "name": "Jose Callaspo",
      "hand": "Both",
      "avg": 0.252,
      "hr": 10,
      "rbi": 53,
      "notes": "Decent contact, switch-hitter, average power."
    },
    {
      "position": "C",
      "name": "Jesus Iannetta",
      "hand": "Right",
      "avg": 0.24,
      "hr": 9,
      "rbi": 26,
      "notes": "Some power, lower batting average overall."
    }
  ]
}'
);

---------------
delete from smartnpc.scene;

-- get tactic suggestions
INSERT INTO smartnpc.scene(scene_id, game_id, scene, status, goal, npcs, knowledge, conv_example_id)
VALUES (
'TACTICS_SELECTION',
'baseball',
'
You are a helpful senior manager in a baseball team.
You provide tactics suggestions and possible outcomes to the manager.
',
'ACTIVATE',
'
Based on the given current state, provide your predictions.
',
'',
'',
'default'
);


-- get lineup suggestions
INSERT INTO smartnpc.scene(scene_id, game_id, scene, status, goal, npcs, knowledge, conv_example_id)
VALUES (
'LINEUP_SUGGESTIONS',
'baseball',
'
You are the baseball team coach in a baseball game.
You create lineup for the game.
',
'ACTIVATE',
'
Based on the given roster of your team and the opponent team,
Create a line up for your team.
',
'',
'',
'default'
);


-- get tactic suggestions - streaming
INSERT INTO smartnpc.scene(scene_id, game_id, scene, status, goal, npcs, knowledge, conv_example_id)
VALUES (
'TACTICS_SELECTION_20250313',
'baseball',
'
You are a helpful senior manager in a baseball team.
You provide tactics suggestions and possible outcomes to the manager.
',
'ACTIVATE',
'
Based on the given current state, provide your predictions.
',
'',
'',
'default'
);
-------------

delete from smartnpc.rosters;
INSERT INTO smartnpc.rosters(
    team_id,
    session_id,
    player_id,
    roster
)
VALUES (
    '1927-New-York-Yankees',
    'random_session2',
    'JackBuser',
    '
{
  "pitchers": [
    {
      "name": "Thomas Anderson",
      "stats": {
        "this_season": {
          "GP": 20,
          "GS": 20,
          "CG": 1,
          "SHO": 1,
          "IP": 104.0,
          "H": 65,
          "R": 38,
          "ER": 36,
          "HR": 6,
          "BB": 44,
          "K": 145
        },
        "career": {
          "GP": 211,
          "GS": 211,
          "CG": 1,
          "SHO": 1,
          "IP": 1096.2,
          "H": 840,
          "R": 419,
          "ER": 389,
          "HR": 108,
          "BB": 495,
          "K": 1368
        }
      }
    },
    {
      "name": "David Brown",
      "stats": {
        "this_season": {
          "GP": 18,
          "GS": 18,
          "CG": 0,
          "SHO": 0,
          "IP": 92.0,
          "H": 72,
          "R": 42,
          "ER": 40,
          "HR": 8,
          "BB": 32,
          "K": 120
        },
        "career": {
          "GP": 185,
          "GS": 185,
          "CG": 2,
          "SHO": 2,
          "IP": 950.1,
          "H": 750,
          "R": 380,
          "ER": 350,
          "HR": 95,
          "BB": 400,
          "K": 1100
        }
      }
    },
     {
      "name": "Maria Garcia",
      "stats": {
        "this_season": {
          "GP": 22,
          "GS": 22,
          "CG": 2,
          "SHO": 1,
          "IP": 120.0,
          "H": 80,
          "R": 35,
          "ER": 32,
          "HR": 5,
          "BB": 28,
          "K": 160
        },
        "career": {
          "GP": 200,
          "GS": 200,
          "CG": 10,
           "SHO": 5,
          "IP": 1100.0,
          "H": 700,
          "R": 300,
          "ER": 275,
          "HR": 75,
          "BB": 350,
          "K": 1250
        }
      }
    },
    {
      "name": "Michael Johnson",
      "stats": {
        "this_season": {
          "GP": 15,
          "GS": 15,
          "CG": 0,
          "SHO": 0,
          "IP": 78.0,
          "H": 60,
          "R": 30,
          "ER": 28,
          "HR": 7,
          "BB": 25,
          "K": 100
        },
        "career": {
          "GP": 160,
          "GS": 160,
          "CG": 5,
          "SHO": 3,
          "IP": 850.0,
          "H": 650,
          "R": 320,
          "ER": 300,
          "HR": 80,
          "BB": 380,
          "K": 1050
        }
      }
    },
    {
      "name": "Jessica Lee",
       "stats": {
        "this_season": {
          "GP": 19,
          "GS": 19,
          "CG": 1,
          "SHO": 1,
          "IP": 98.0,
          "H": 70,
          "R": 32,
          "ER": 30,
          "HR": 4,
          "BB": 35,
          "K": 130
        },
        "career": {
          "GP": 195,
          "GS": 195,
          "CG": 8,
          "SHO": 4,
          "IP": 1000.0,
          "H": 780,
          "R": 350,
          "ER": 320,
          "HR": 90,
          "BB": 420,
          "K": 1200
        }
      }
    },
     {
      "name": "Kevin Rodriguez",
      "stats": {
         "this_season": {
          "GP": 21,
          "GS": 21,
          "CG": 0,
          "SHO": 0,
          "IP": 110.0,
          "H": 85,
          "R": 45,
          "ER": 42,
          "HR": 9,
          "BB": 40,
          "K": 150
        },
        "career": {
           "GP": 220,
          "GS": 220,
          "CG": 3,
          "SHO": 1,
          "IP": 1150.0,
          "H": 900,
          "R": 450,
          "ER": 420,
          "HR": 110,
          "BB": 500,
          "K": 1400
        }
      }
    },
    {
      "name": "Ashley Wilson",
      "stats": {
         "this_season": {
          "GP": 17,
          "GS": 17,
          "CG": 2,
          "SHO": 2,
          "IP": 90.0,
          "H": 60,
          "R": 25,
          "ER": 22,
          "HR": 3,
          "BB": 20,
          "K": 110
        },
        "career": {
          "GP": 175,
          "GS": 175,
          "CG": 12,
          "SHO": 7,
          "IP": 900.0,
          "H": 680,
          "R": 280,
          "ER": 250,
          "HR": 70,
          "BB": 300,
          "K": 1150
        }
      }
    }
  ],
  "fielders": [
    {
      "position": "C",
      "name": "Jake Miller",
      "hand": "R",
      "avg": 0.275,
      "hr": 15,
      "rbi": 75,
      "notes": "Solid defense, decent bat."
    },
    {
      "position": "1B",
      "name": "Emily Davis",
      "hand": "L",
      "avg": 0.305,
      "hr": 22,
      "rbi": 90,
      "notes": "Power hitter, average defense."
    },
    {
      "position": "2B",
      "name": "Carlos Sanchez",
      "hand": "R",
      "avg": 0.28,
      "hr": 10,
      "rbi": 55,
      "notes": "Good contact hitter, speedy."
    },
    {
      "position": "SS",
      "name": "Sarah Jones",
      "hand": "L",
      "avg": 0.26,
      "hr": 5,
      "rbi": 40,
       "notes": "Excellent fielder, good on-base percentage."
    },
    {
      "position": "3B",
      "name": "Brandon Lee",
      "hand": "R",
      "avg": 0.295,
      "hr": 18,
      "rbi": 80,
       "notes": "Consistent hitter, good arm."
    },
    {
      "position": "LF",
      "name": "Megan Green",
      "hand": "L",
      "avg": 0.27,
      "hr": 12,
      "rbi": 65,
       "notes": "Good range, average hitter."
    },
    {
      "position": "CF",
      "name": "Tyler Wilson",
      "hand": "R",
      "avg": 0.315,
      "hr": 8,
      "rbi": 50,
       "notes":"Leadoff hitter, good speed."
    },
    {
      "position": "RF",
      "name": "Kayla Martinez",
      "hand": "L",
      "avg": 0.29,
      "hr": 16,
      "rbi": 70,
       "notes": "Strong arm, good power."
    },
    {
      "position": "DH",
      "name": "Christopher Garcia",
      "hand": "R",
      "avg": 0.285,
      "hr": 20,
      "rbi": 85,
       "notes": "Power hitter, clutch performer."
    }
  ]
}
    '
);

INSERT INTO smartnpc.rosters(
    team_id,
    session_id,
    player_id,
    roster
)
VALUES (
    '1969-New-York-Mets',
    'random_session2',
    'Computer',
    '
{
  "pitchers": [
    {
      "name": "Maria Garcia",
      "stats": {
        "this_season": {
          "GP": 18,
          "GS": 17,
          "CG": 2,
          "SHO": 1,
          "IP": 98.2,
          "H": 72,
          "R": 35,
          "ER": 32,
          "HR": 8,
          "BB": 28,
          "K": 132
        },
        "career": {
          "GP": 192,
          "GS": 185,
          "CG": 9,
          "SHO": 6,
          "IP": 1050.1,
          "H": 785,
          "R": 395,
          "ER": 360,
          "HR": 92,
          "BB": 410,
          "K": 1280
        }
      }
    },
    {
      "name": "David Lee",
      "stats": {
        "this_season": {
          "GP": 22,
          "GS": 22,
          "CG": 0,
          "SHO": 0,
          "IP": 118.0,
          "H": 85,
          "R": 48,
          "ER": 45,
          "HR": 11,
          "BB": 35,
          "K": 155
        },
        "career": {
          "GP": 208,
          "GS": 205,
          "CG": 3,
          "SHO": 2,
          "IP": 1125.3,
          "H": 810,
          "R": 430,
          "ER": 405,
          "HR": 105,
          "BB": 465,
          "K": 1390
        }
      }
    },
    {
      "name": "Jessica Brown",
      "stats": {
        "this_season": {
          "GP": 15,
          "GS": 14,
          "CG": 1,
          "SHO": 0,
          "IP": 82.1,
          "H": 62,
          "R": 28,
          "ER": 25,
          "HR": 5,
          "BB": 22,
          "K": 115
        },
        "career": {
          "GP": 165,
          "GS": 158,
          "CG": 6,
          "SHO": 3,
          "IP": 890.2,
          "H": 705,
          "R": 315,
          "ER": 290,
          "HR": 78,
          "BB": 350,
          "K": 1210
        }
      }
    },
    {
      "name": "Michael Wilson",
      "stats": {
        "this_season": {
          "GP": 19,
          "GS": 19,
          "CG": 2,
          "SHO": 1,
          "IP": 105.2,
          "H": 78,
          "R": 32,
          "ER": 29,
          "HR": 7,
          "BB": 30,
          "K": 140
        },
        "career": {
          "GP": 182,
          "GS": 178,
          "CG": 8,
          "SHO": 5,
          "IP": 960.0,
          "H": 750,
          "R": 360,
          "ER": 335,
          "HR": 85,
          "BB": 420,
          "K": 1250
        }
      }
    },
    {
      "name": "Ashley Rodriguez",
       "stats": {
        "this_season": {
          "GP": 21,
          "GS": 20,
          "CG": 0,
          "SHO": 0,
          "IP": 112.0,
          "H": 90,
          "R": 52,
          "ER": 49,
          "HR": 12,
          "BB": 40,
          "K": 160
        },
        "career": {
          "GP": 202,
          "GS": 198,
          "CG": 4,
          "SHO": 2,
          "IP": 1080.1,
          "H": 820,
          "R": 450,
          "ER": 425,
           "HR": 115,
          "BB": 480,
          "K": 1420
        }
      }
    },
    {
      "name": "Kevin Martinez",
       "stats": {
         "this_season": {
          "GP": 16,
          "GS": 15,
          "CG": 1,
          "SHO": 1,
          "IP": 88.1,
          "H": 68,
          "R": 25,
          "ER": 22,
          "HR": 4,
          "BB": 25,
          "K": 120
        },
        "career": {
          "GP": 175,
          "GS": 170,
          "CG": 7,
          "SHO": 5,
          "IP": 940.3,
          "H": 760,
          "R": 330,
          "ER": 305,
          "HR": 75,
          "BB": 380,
          "K": 1300
        }
      }
    },
    {
      "name": "Sarah Anderson",
      "stats": {
        "this_season": {
          "GP": 23,
          "GS": 23,
          "CG": 3,
          "SHO": 2,
          "IP": 125.0,
          "H": 82,
          "R": 30,
          "ER": 27,
          "HR": 6,
          "BB": 20,
          "K": 170
        },
         "career": {
          "GP": 215,
          "GS": 210,
          "CG": 11,
          "SHO": 8,
          "IP": 1150.2,
          "H": 790,
          "R": 350,
          "ER": 320,
          "HR": 80,
          "BB": 390,
          "K": 1450
        }
      }
    }
  ],
   "fielders": [
    {
      "position": "C",
      "name": "Samuel Rivera",
      "hand": "R",
      "avg": 0.260,
      "hr": 12,
      "rbi": 60,
      "notes": "Good defensive catcher, improving bat."
    },
    {
      "position": "1B",
      "name": "Olivia Chen",
      "hand": "L",
      "avg": 0.320,
      "hr": 25,
      "rbi": 100,
      "notes": "Power hitter, solid defender."
    },
    {
      "position": "2B",
      "name": "Daniel Kim",
      "hand": "R",
      "avg": 0.290,
      "hr": 8,
      "rbi": 50,
      "notes": "Excellent fielder, consistent hitter."
    },
    {
      "position": "SS",
      "name": "Sophia Rodriguez",
      "hand": "R",
      "avg": 0.275,
      "hr": 10,
      "rbi": 55,
       "notes": "Good range, strong arm at short."
    },
    {
      "position": "3B",
      "name": "Ethan Brown",
      "hand": "L",
      "avg": 0.300,
      "hr": 20,
      "rbi": 90,
      "notes": "Power hitter, clutch performer."
    },
    {
      "position": "LF",
      "name": "Ava Davis",
      "hand": "L",
      "avg": 0.280,
      "hr": 14,
      "rbi": 70,
      "notes": "Speedy outfielder, good on-base percentage."
    },
    {
      "position": "CF",
      "name": "Noah Wilson",
      "hand": "R",
      "avg": 0.310,
      "hr": 7,
      "rbi": 45,
       "notes": "Leadoff hitter, great speed."
    },
    {
      "position": "RF",
      "name": "Isabella Garcia",
      "hand": "R",
      "avg": 0.295,
      "hr": 17,
      "rbi": 80,
       "notes": "Strong arm, consistent power threat."
    },
     {
      "position": "DH",
      "name": "Jackson Smith",
      "hand": "L",
      "avg": 0.285,
      "hr": 22,
      "rbi": 95,
       "notes": "Designated hitter, pure power hitter."
    }
  ]
}
    '
);

------------

delete from smartnpc.prompt_template;
-- ############################## --
--      GENERAL
-- ############################## --
INSERT INTO smartnpc.prompt_template(prompt_id, game_id, scene_id, prompt_template, is_activate)
VALUES (
'OUTPUT_FORMAT',
'baseball',
'default',
'"3-5 word state summary": chance% [10 value state array in the Input Format]

',
True
);


INSERT INTO smartnpc.prompt_template(prompt_id, game_id, scene_id, prompt_template, is_activate)
VALUES (
'INPUT_FORMAT',
'baseball',
'default',
'
You will be given current state in the following format:
[
runner on first (true | false),
runner on second (true | false),
runner on third (true | false),
balls (0,1,2,3),
strikes (0,1,2),
outs (0,1,2),
inning (0...12),
defensive score lead (offensive score - defensive score),
defensive team play style (0: conservative, 1: assertive, 2: aggressive),
offensive team play style (0: conservative, 1: assertive, 2: aggressive)
]',
True
);


-- ## Line up ## --
INSERT INTO smartnpc.prompt_template(prompt_id, game_id, scene_id, prompt_template, is_activate)
VALUES (
'LINEUP_OUTPUT_FORMAT',
'baseball',
'LINEUP_SUGGESTIONS',
'
{
    "explain": "explain the line up",
    "lineup":
    [
        {
            "player_name": player name,
            "defensive_position" : defensive position,
        }
    ],
    "starting_pitcher": player name
}
',
True
);

INSERT INTO smartnpc.prompt_template(prompt_id, game_id, scene_id, prompt_template, is_activate)
VALUES (
'NPC_CONVERSATION_SCENE_GOAL_TEMPLATE',
'baseball',
'LINEUP_SUGGESTIONS',
'# SYSTEM
You are an in-game coach of a baseball simulation game.
You will be given rosters of matching teams,
base on the roster, you create the lineup for your team.

## Your Tasks

1. You will be given roster of both teams.

2. **Base on the roster** create the lineup for your team.
    * Carefully examine the roster to generate lineup that has best chance to win.

## Output Format

{LINEUP_OUTPUT_FORMAT}

## Important
* Do not include headers, explanations, or extraneous information.
* Walkthrough the roster information.
* Think step by step, make sure the lineup is valid.

',
True
);


INSERT INTO smartnpc.prompt_template(prompt_id, game_id, scene_id, prompt_template, is_activate)
VALUES (
'NPC_CONVERSATION_SCENE_GOAL_TEMPLATE',
'baseball',
'TACTICS_SELECTION',
'

# SYSTEM
This is a baseball management video game where one player is controlling the home team and
another the away team. The player controls what the team does by selecting what
the coach will tell the batter or pitcher for each at-bat.

## YOUR TASKS

Based on the current game state and statistics, create options for the coaching
scripts that the video game displays to the players. Each script should be 20-40
words and advocate for a distinctly different
approach to the current at-bat that makes sense given the current state of the
baseball game.  For each combination of the batting and pitching tactics,
generate a valid possible outcome of the current at-bat if the players select that
combination of tactics.  Outcomes must represent the entire at-bat, and will
always result in either a hit or an out. Be sure to double-check that the
outcome makes sense given the rules of baseball.

Also create a meta-level tutorial script for each player, telling them which option
they should choose and why.


## Output
Taking into account the pitcher and batter statics and current state of the
game, make 3 pitching tactics scripts, and 3 batting tactics scripts. For each
of the 9 possible batting + pitching tactics combinations, generate a possible
outcome of the current at-bat that results. If you refer to a team member in a
script, be sure to use their last name.

## IMPORT RULES

Finally, In the voice of a friendly video game tutorial text box, explain to the
player controlling the pitching team how to select a pitching tactic, which
tactic you think they should select, and why (~50 words) Using the same
approach, also explain how to select a batting tactic to the player controlling
the batting team.  Do not refer to tactic indicies in the script, because those are
an implementation detail the players don''t know about.

## OUTPUT FORMAT
Use this json schema for the tactics scripts and possible outcomes:
{TACTICS_OUTPUT_SCHEMA}

Here is a table describing each part of the JSON schema:

{TACTICS_OUTPUT_SCHEMA_DESCRIPTION}

Don''t include any headers or additional explanation outside of this output format.
',
True
);

INSERT INTO smartnpc.prompt_template(prompt_id, game_id, scene_id, prompt_template, is_activate)
VALUES (
'TACTICS_OUTPUT_SCHEMA_DESCRIPTION',
'baseball',
'TACTICS_SELECTION',
'
Element Name	Type	Description
tactics	object	Contains the pitching and batting tactic scripts.
tactics.pitching	array	An array of strings, where each string is a pitching tactic script that advances the goals of the pitcher.
tactics.batting	array	An array of strings, where each string is a batting tactic script that advances the goals of the pitcher.
outcomes	object	A map where keys are strings representing the pitching and batting tactic indices (e.g., "0.0", "0.1", etc.) and values are objects describing the outcome of the at-bat.
outcomes[key].outcome	string	A string describing the play that occurred (e.g., "Flyout to Center Field").
outcomes[key].game_state	object	An object describing the state of the game after the at-bat, if this outcome were to occur.
outcomes[key].game_state.r1	boolean	true if a runner is on first base; false otherwise.
outcomes[key].game_state.r2	boolean	true if a runner is on second base; false otherwise.
outcomes[key].game_state.r3	boolean	true if a runner is on third base; false otherwise.
outcomes[key].game_state.outs	integer	The number of outs after the play.
outcomes[key].game_state.runs	integer	The number of runs scored as a result of this play.
outcomes[key].title	string	A brief description of the outcome (e.g., "Ground ball double play").
recommendations	object	Contains the video game tutorial coach''s recommended pitching and batting tactics and rationales.
recommendations.pitching	object	Contains a game tutorial for selecting the recommended pitching tactic.
recommendations.pitching.index	integer	The index (starting from 0) of the recommended pitching tactic within the tactics.pitching array.
recommendations.pitching.script	string	The tutorial text script explaining the recommended pitching tactic.
recommendations.batting	object	Contains a game tutorial for selecting the recommended batting tactic.
recommendations.batting.index	integer	The index (starting from 0) of the recommended batting tactic within the tactics.batting array.
recommendations.batting.script	string	The tutorial text explaining the recommended batting tactic.
',
True
);


INSERT INTO smartnpc.prompt_template(prompt_id, game_id, scene_id, prompt_template, is_activate)
VALUES (
'TACTICS_OUTPUT_SCHEMA',
'baseball',
'TACTICS_SELECTION',
'
{
  "type": "object",
  "properties": {
    "tactics": {
      "type": "object",
      "properties": { "pitching": { "type": "array", "items": { "type": "string" } }, "batting": { "type": "array", "items": { "type": "string" } } },
      "required": ["pitching", "batting"]
    },
    "outcomes": {
      "type": "object",
      "additionalProperties": {
        "type": "object",
        "properties": {
          "outcome": { "type": "string" },
          "game_state": {
            "type": "object",
            "properties": {
              "r1": { "type": "boolean" },
              "r2": { "type": "boolean" },
              "r3": { "type": "boolean" },
              "outs": { "type": "integer" },
              "runs": { "type": "integer" }
            },
            "required": ["r1", "r2", "r3", "outs", "runs"]
          },
          "title": { "type": "string" }
        },
        "required": ["outcome", "game_state", "title"]
      }
    },
    "recommendations": {
      "type": "object",
      "properties": {
        "pitching": {
          "type": "object",
          "properties": { "index": { "type": "integer" }, "script": { "type": "string" } },
          "required": ["index", "script"]
        },
        "batting": {
          "type": "object",
          "properties": { "index": { "type": "integer" }, "script": { "type": "string" } },
          "required": ["index", "script"]
        }
      },
      "required": ["pitching", "batting"]
    }
  },
  "required": ["tactics", "outcomes", "recommendations"]
}

const exampleTopOfFirstResponse = {
  "tactics": {
    "pitching": [
      "Work the corners, keep it low and away. He''s a righty power hitter, so avoid letting him extend his arms.",
      "Mix up your pitches. Throw some fastballs inside to jam him, then come back with breaking balls away to keep him off balance.",
      "Try to get ahead in the count. If you get to 0-2, throw a slider or changeup. He may be looking fastball early."
    ],
    "batting": [
      "Be patient, Joseph. Green has a high walk rate. Don''t be afraid to take a walk if he''s not throwing strikes. First at-bat, see what he''s got.",
      "Look for a fastball early in the count. He''s likely to try and establish his fastball. Be ready to jump on it.",
      "Try to work the count. Green has given up a lot of hits. The deeper you get into the at-bat, the more likely you are to find a pitch you can hit."
    ]
  },
  "outcomes": {
    "0.0": {
      "outcome": "Strikeout looking.",
      "game_state": {
        "r1": false,
        "r2": false,
        "r3": false,
        "outs": 1,
        "runs": 0
      },
      "title": "Strikeout"
    },
    "0.1": {
      "outcome": "Groundout to second base.",
      "game_state": {
        "r1": false,
        "r2": false,
        "r3": false,
        "outs": 1,
        "runs": 0
      },
      "title": "Groundout"
    },
    "0.2": {
      "outcome": "Walk.",
      "game_state": {
        "r1": true,
        "r2": false,
        "r3": false,
        "outs": 0,
        "runs": 0
      },
      "title": "Walk"
    },
    "1.0": {
      "outcome": "Foul tip, strike three.",
      "game_state": {
        "r1": false,
        "r2": false,
        "r3": false,
        "outs": 1,
        "runs": 0
      },
      "title": "Strikeout"
    },
    "1.1": {
      "outcome": "Line drive single to left field.",
      "game_state": {
        "r1": true,
        "r2": false,
        "r3": false,
        "outs": 0,
        "runs": 0
      },
      "title": "Single"
    },
    "1.2": {
      "outcome": "Flyout to center field.",
      "game_state": {
        "r1": false,
        "r2": false,
        "r3": false,
        "outs": 1,
        "runs": 0
      },
      "title": "Flyout"
    },
    "2.0": {
      "outcome": "Swinging strikeout.",
      "game_state": {
        "r1": false,
        "r2": false,
        "r3": false,
        "outs": 1,
        "runs": 0
      },
      "title": "Strikeout"
    },
    "2.1": {
      "outcome": "Ground ball to shortstop, out at first.",
      "game_state": {
        "r1": false,
        "r2": false,
        "r3": false,
        "outs": 1,
        "runs": 0
      },
      "title": "Groundout"
    },
    "2.2": {
      "outcome": "Double to left field.",
      "game_state": {
        "r1": false,
        "r2": true,
        "r3": false,
        "outs": 0,
        "runs": 0
      },
      "title": "Double"
    }
  },
  "recommendations": {
    "pitching": "Pitching tactic 0: Work the corners.  This catcher has some power, so keep the ball away from his sweet spot.",
    "batting": "Batting tactic 1: Be patient. The pitcher walks a lot of guys. Let him work and try to get on base."
  }
}
',
True
);

--------

-- get tactic suggestions - streaming
INSERT INTO smartnpc.scene(scene_id, game_id, scene, status, goal, npcs, knowledge, conv_example_id)
VALUES (
'TACTICS_SELECTION_20250317_011',
'baseball',
'
You are a helpful senior manager in a baseball team.
You provide tactics suggestions and possible outcomes to the manager.
',
'ACTIVATE',
'
Based on the given current state, provide your predictions.
',
'',
'',
'default'
);

delete from smartnpc.prompt_template where
scene_id='TACTICS_SELECTION_20250317_011';

INSERT INTO smartnpc.prompt_template(prompt_id, game_id, scene_id, prompt_template, is_activate)
VALUES (
'STREAMING_GET_SUGGESTIONS',
'baseball',
'TACTICS_SELECTION_20250317_011',
'# SYSTEM
This is a baseball management video game where one player is controlling the home team and
another the away team. The player controls what the team does by selecting what
the coach will tell the batter or pitcher for each at-bat.

## YOUR TASKS

Based on the current game state and statistics, create options for the coaching
scripts that the video game displays to the players. Each script should be 20-40
words and advocate for a distinctly different
approach to the current at-bat that makes sense given the current state of the
baseball game.  For each combination of the batting and pitching tactics,
generate a valid possible outcome of the current at-bat if the players select that
combination of tactics. Outcomes must represent the entire at-bat and will
always result in either a hit or an out. Be sure to double-check that the
outcome makes sense given the rules of baseball.

Also create a meta-level tutorial script for each player, telling them which option
they should choose and why.

## Output
Taking into account the pitcher and batter statics and current state of the
game, make 3 pitching tactics scripts, and 3 batting tactics scripts. For each
of the 9 possible batting + pitching tactics combinations, generate a possible
outcome of the current at-bat that results. If you refer to a team member in a
script, be sure to use their last name.

## IMPORT RULES

Finally, In the voice of a friendly video game tutorial text box, explain to the
player controlling the pitching team how to select a pitching tactic, which
tactic you think they should select, and why (~50 words) Using the same
approach, also explain how to select a batting tactic to the player controlling
the batting team.  Do not refer to tactic indicies in the script, because those are
an implementation detail the players don''t know about.

## IMPORTANT

*   When generating the outcome of an at-bat, consider the current game state (runners on base, outs, score) and ensure the outcome is logically consistent. For example:
    *   A walk with the bases loaded MUST result in a run scored and the runner on first advancing to second, the runner on second advancing to third, and the runner on third scoring.  The number of outs MUST remain the same.
    *   A fly ball with runners on first and second and one out CANNOT be a sacrifice fly.
    *   The outcome **MUST BE VALIDATE**, for example, double play isn''t valid if no runner on base.
    *   If there are 2 outs, any play that results in the batter being out MUST also result in the end of the inning.
    *   If a runner is on first, a walk MUST result in the runner on first advancing to second.
    *   If a runner is on second, a sacrifice fly is impossible.
*   **Game End Condition**:
    *   The game ends when the home team is winning after the away team finishes batting in the top of the 9th inning.
    *   The game ends when the home team is ahead at the end of any subsequent inning after the 9th.
    *   If the home team is batting in the bottom of the 9th inning (or any extra inning) and takes the lead, the game is over immediately.
*   **About Home Runs**:
    *   A home run with no runners on base results in 1 run scored and no outs recorded.
    *   If the home team hits a home run in the bottom of the 9th inning or later to take the lead, the game ends immediately, and the number of outs should reflect the state before the home run.
    *   If there are already two outs, home run does not cause 3 outs.
    *   **A home run NEVER results in an out.** This is extremely important. The batter and any runners on base always score.
*   **About other plays**:
    *   If the batter hits the ball but reaches first base due to a fielding error, the number of outs does not increase.
    *   A foul ball should always results in an out. Because this is a per `at-bat` outcome. a at-bat with foul ball outcome should always indicates an out.
    * **Fielder''s Choice:** If the batter hits a ground ball and a fielder attempts to get a runner out at a base other than first, but fails, the batter is safe at first. This is scored as a fielder''s choice.  Runners may advance, and the number of outs remains the same *unless* the attempt at an out results in the third out.
*   **About ending the inning:**
    *   If there are already two outs, and the at-bat results in an out, you MUST indicate that the inning is over in the outcome (e.g., "Groundout to first base, inning over."). The number of outs MUST be 3.
    *   If there are fewer than two outs, and the at-bat results in a double play, you MUST indicate that the inning is over in the outcome (e.g., "Double play, inning over"). The number of outs MUST be 3.
    *   **Crucially, if there are two outs and the current at-bat does NOT result in an out, the inning MUST continue (outs remain at 2), and runners should advance appropriately based on the outcome of the play.**  For example, a single will put the batter on first.  A double will put the batter on second.  A walk will put the batter on first and force other runners to advance.
*   **About Walks:**
    *   A walk always puts the batter on first base.
    *   A walk **does not** result in an out.
    *   If there is a runner on first, a walk forces that runner to advance to second.
    *   If there are runners on first and second, a walk forces the runner on second to advance to third and the runner on first to advance to second, and the batter is on first.
    *   **If the bases are loaded (runners on first, second, and third), a walk MUST result in a run being scored, and all runners advance one base.**  This is a crucial rule; ensure the `runs` value in the `game_state` is updated correctly. After a walk with bases loaded, remember to set `r3` to `false`
*   **About Sacrifice Flies:**
    *   A runner on second or first cannot advance to home with a sacrifice fly.
    *   If a runner on third is on the base and the batter hits a flyout, the runner on third will score.
*   **Inning Over:**
    *   Inning is over *ONLY* when the 3rd out occurs.
*   **About Double Play:**
    *   Double plays are only possible if there is a runner on first base.
    *   If there are 2 outs, and the at-bat results in a double play, you MUST indicate that the inning is over in the outcome (e.g., "Double play, inning over"). The number of outs MUST be 3.
* **Advancing Runners:** When a batter gets a hit (single, double, triple), runners on base MUST advance the appropriate number of bases. A single advances each runner one base. A double advances each runner two bases. A triple advances each runner three bases.
* **Runs Scored**: Remember that runs are only scored when a player crosses home plate.  A groundout or flyout *does not* score a run unless a runner is on third and tags up (for a flyout) or is forced home (e.g., bases loaded walk). A single, double, or triple only scores runs if runners are in position to reach home plate. Carefully track runs scored.

## OUTPUT FORMAT
Use this json schema for output, split each parts by a tag: <tactics>, <recommendations> and <outcomes>.
<tactics>
{
  "type": "object",
  "properties": {
    "tactics": {
      "type": "object",
      "properties": { "pitching": { "type": "array", "items": { "type": "string" } }, "batting": { "type": "array", "items": { "type": "string" } } },
      "required": ["pitching", "batting"]
    }
}
</tactics>
<recommendations>
{
  "type": "object",
  "properties": {
    "recommendations": {
      "type": "object",
      "properties": {
        "pitching": {
          "type": "object",
          "properties": { "index": { "type": "integer" }, "script": { "type": "string" } },
          "required": ["index", "script"]
        },
        "batting": {
          "type": "object",
          "properties": { "index": { "type": "integer" }, "script": { "type": "string" } },
          "required": ["index", "script"]
        }
      },
      "required": ["pitching", "batting"]
    }
  },
  "required": ["tactics", "outcomes", "recommendations"]
}
</recommendations>
<outcomes>
{
  "type": "object",
  "properties": {
    "outcomes": {
      "type": "object",
      "additionalProperties": {
        "type": "object",
        "properties": {
          "outcome": { "type": "string" },
          "game_state": {
            "type": "object",
            "properties": {
              "r1": { "type": "boolean" },
              "r2": { "type": "boolean" },
              "r3": { "type": "boolean" },
              "outs": { "type": "integer" },
              "runs": { "type": "integer" }
            },
            "required": ["r1", "r2", "r3", "outs", "runs"]
          },
          "title": { "type": "string" }
        },
        "required": ["outcome", "game_state", "title"]
      }
    }
}
</outcomes>


Example:
<tactics>
{
  "tactics": {
    "pitching": [
      "Work the corners, keep it low and away. He''s a righty power hitter, so avoid letting him extend his arms.",
      "Mix up your pitches. Throw some fastballs inside to jam him, then come back with breaking balls away to keep him off balance.",
      "Try to get ahead in the count. If you get to 0-2, throw a slider or changeup. He may be looking fastball early."
    ],
    "batting": [
      "Be patient, Joseph. Green has a high walk rate. Don''t be afraid to take a walk if he''s not throwing strikes. First at-bat, see what he''s got.",
      "Look for a fastball early in the count. He''s likely to try and establish his fastball. Be ready to jump on it.",
      "Try to work the count. Green has given up a lot of hits. The deeper you get into the at-bat, the more likely you are to find a pitch you can hit."
    ]
  }
}
</tactics>
<recommendations>
{
  "recommendations": {
    "pitching": "Pitching tactic 0: Work the corners.  This catcher has some power, so keep the ball away from his sweet spot.",
    "batting": "Batting tactic 1: Be patient. The pitcher walks a lot of guys. Let him work and try to get on base."
  }
}
</recommendations>
<outcomes>
{
  "outcomes": {
    "0.0": {
      "outcome": "Strikeout looking.",
      "game_state": {
        "r1": false,
        "r2": false,
        "r3": false,
        "outs": 1,
        "runs": 0
      },
      "title": "Strikeout"
    },
    "0.1": {
      "outcome": "Groundout to second base.",
      "game_state": {
        "r1": false,
        "r2": false,
        "r3": false,
        "outs": 1,
        "runs": 0
      },
      "title": "Groundout"
    },
    "0.2": {
      "outcome": "Walk.",
      "game_state": {
        "r1": true,
        "r2": false,
        "r3": false,
        "outs": 0,
        "runs": 0
      },
      "title": "Walk"
    },
    "1.0": {
      "outcome": "Foul tip, strike three.",
      "game_state": {
        "r1": false,
        "r2": false,
        "r3": false,
        "outs": 1,
        "runs": 0
      },
      "title": "Strikeout"
    },
    "1.1": {
      "outcome": "Line drive single to left field.",
      "game_state": {
        "r1": true,
        "r2": false,
        "r3": false,
        "outs": 0,
        "runs": 0
      },
      "title": "Single"
    },
    "1.2": {
      "outcome": "Flyout to center field.",
      "game_state": {
        "r1": false,
        "r2": false,
        "r3": false,
        "outs": 1,
        "runs": 0
      },
      "title": "Flyout"
    },
    "2.0": {
      "outcome": "Swinging strikeout.",
      "game_state": {
        "r1": false,
        "r2": false,
        "r3": false,
        "outs": 1,
        "runs": 0
      },
      "title": "Strikeout"
    },
    "2.1": {
      "outcome": "Ground ball to shortstop, out at first.",
      "game_state": {
        "r1": false,
        "r2": false,
        "r3": false,
        "outs": 1,
        "runs": 0
      },
      "title": "Groundout"
    },
    "2.2": {
      "outcome": "Double to left field.",
      "game_state": {
        "r1": false,
        "r2": true,
        "r3": false,
        "outs": 0,
        "runs": 0
      },
      "title": "Double"
    }
  }
}
</outcomes>

Here is a table describing each part of the output schema:

Element Name    Type    Description
tactics object  Contains the pitching and batting tactic scripts.
tactics.pitching        array   An array of strings, where each string is a pitching tactic script that advances the goals of the pitcher.
tactics.batting array   An array of strings, where each string is a batting tactic script that advances the goals of the pitcher.
outcomes        object  A map where keys are strings representing the pitching and batting tactic indices (e.g., "0.0", "0.1", etc.) and values are objects describing the outcome of the at-bat.
outcomes[key].outcome   string  A string describing the play that occurred (e.g., "Flyout to Center Field"). The outcome **MUST BE VALIDATE**, for example, double play isn''t valid if no runner on base. If the outcome resulting an out, you must explictly indicate Out in the outcome string.
outcomes[key].game_state        object  An object describing the state of the game after the at-bat, if this outcome were to occur.
outcomes[key].game_state.r1     boolean true if a runner is on first base; false otherwise.
outcomes[key].game_state.r2     boolean true if a runner is on second base; false otherwise.
outcomes[key].game_state.r3     boolean true if a runner is on third base; false otherwise.
outcomes[key].game_state.outs   integer The number of outs after the play.
outcomes[key].game_state.runs   integer The number of runs scored as a result of this play.
outcomes[key].title     string  A brief description of the outcome (e.g., "Ground ball double play").
recommendations object  Contains the video game tutorial coach''s recommended pitching and batting tactics and rationales.
recommendations.pitching        object  Contains a game tutorial for selecting the recommended pitching tactic.
recommendations.pitching.index  integer The index (starting from 0) of the recommended pitching tactic within the tactics.pitching array.
recommendations.pitching.script string  The tutorial text script explaining the recommended pitching tactic. Simply give the explaination, DO NOT include any index number, jus talk like a coach to player.
recommendations.batting object  Contains a game tutorial for selecting the recommended batting tactic.
recommendations.batting.index   integer The index (starting from 0) of the recommended batting tactic within the tactics.batting array.
recommendations.batting.script  string  The tutorial text explaining the recommended batting tactic.

Don''t include any headers or additional explanation outside of this output format.

',
True
);
