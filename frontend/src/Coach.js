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

// Coach is a class that displays the coaching script to the player. They must
// click though the coaching window to advance the game state, this class
// provides the ability to display a window and 'resolve' it when it has been
// clicked so the player can continue playing.
class Coach {
  constructor(config) {
    this.title = config.title
    this.recommendation = config.recommendation
    this.resolve = config.resolve // Function called after the player makes their selection (the 'event handler')
    this.teamColor = config.teamColor || "blue"
    this.teamRole = config.teamRole || "Default"
    this.imgSrc = config.imgSrc
    this.logoSrc = config.logoSrc
  }

  // Attempt to ack the message box. 
  ack(selection) {
    // Fade, and remove on animation end
    this.element.classList.add("fade-out");
    this.element.addEventListener("animationend", () => {
      this.resolve(selection) // Call the event handler function provided by the code that created this object.
      this.parent.removeChild(this.element)
      this.onComplete()
    }, { once: true })
  }

  display(parent, onComplete) {
    this.parent = parent
    this.onComplete = onComplete
    this.element = document.createElement('div')
    this.element.classList.add("greyTransparentBG")
    this.element.classList.add("fontDefaults")
    this.element.classList.add(`optionSelectionDefault`)
    this.element.classList.add(`optionSelection-${this.teamRole}`)
    this.element.classList.add(`${this.teamColor}Border`)
    this.element.classList.add("fade-in");
    this.element.addEventListener("animationend", () => {
      console.log(`click for ${this.title} active`)
      // message box has finished fading in and is now interactable
      ackButton.addEventListener("click", () => {
        console.log("coach dismiss button pushed")
        this.ack()
      })
    }, { once: true })

    // coaching text 
    const coachScript = document.createElement("div")
    coachScript.classList.add(`coaching-${this.teamRole}`);

    // Dialog box title 
    let geminiLogo = document.createElement("img")
    geminiLogo.classList.add(`coachLogo`)
    geminiLogo.classList.add(`coachLogo-${this.teamRole}`)
    geminiLogo.src = (this.logoSrc)
    coachScript.appendChild(geminiLogo)

    let title = document.createElement("div")
    title.classList.add(`coachTitle`)
    title.classList.add(`coachTitle-${this.teamRole}`)
    title.textContent = this.title

    // Coaching script
    let description = document.createElement("div")
    description.textContent = this.recommendation.script

    coachScript.appendChild(title)
    coachScript.appendChild(description)
    this.element.appendChild(coachScript)

    // Button to accept the currently displayed tactic.
    const ackButton = document.createElement("div")
    ackButton.classList.add("acceptButton")
    ackButton.textContent = "Got it!"
    this.element.appendChild(ackButton)

    const coachHead = document.createElement('img')
    coachHead.src = this.imgSrc
    coachHead.classList.add('coachHead')
    coachHead.classList.add(`coachHead-${this.teamRole}`)
    this.element.appendChild(coachHead)

    // add everything to the DOM 
    this.parent.appendChild(this.element)
  }
}

export default Coach;