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

// Object that contains any number of text boxes to display, from which the player can choose 1.
// When making the OptionSelection object, the calling code should set the '{resolve: }'  key to
// a function that handles the player's selection (it's an event handler). 
class OptionSelection {
  constructor(config) {
    this.speed = config.speed || 10;  // Speed at which the text in the option textboxes is revealed.
    this.options = config.options // Array of options the player can select from
    this.resolve = config.resolve // Function called after the player makes their selection (the 'event handler')
    this.headerText = config.headerText // Text to put above the option selection
    this.recommendedOptionIndex = config.recommendedOptionIndex  // index of the option to highlight as recommended
    this.sceneId = config.sceneId || "" // Scene ID the creating code can optionally specify
    this.teamColor = config.teamColor || "blue"
    this.teamRole = config.teamRole || "Default"
    this.doneTyping = false;
  }

  // Attempt to ack the message box. 
  ack(selection) {
    // remove this div
    this.element.classList.add("fade-out");
    this.element.addEventListener("animationend", () => {
      this.resolve(selection) // Call the event handler function provided by the code that created this object.
      this.parent.removeChild(this.element)
      this.onComplete();
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
      console.log(`click for ${option.title} active`)
      // message box has finished fading in and is now interactable
      ackButton.addEventListener("click", () => {
        console.log("accept button pushed")
        this.ack({
          text: option.text,
          title: option.title,
          index: option.index,
          sceneId: this.sceneId,
        })
      })
    }, { once: true })

    // player call to action
    const header = document.createElement("div")
    header.textContent = this.headerText
    this.element.appendChild(header)

    // Buttons used to select the options
    let index = 0
    let option = this.options[index]
    let selectorButtons = []

    // Container to hold the buttons and space them evenly
    const selectionButtonContainer = document.createElement("div")
    selectionButtonContainer.classList.add("optionSelectionButtonContainer")
    this.element.appendChild(selectionButtonContainer)

    // Make buttons
    for (let i = 0; i < this.options.length; i++) {
      selectorButtons[i] = document.createElement("button")
      selectorButtons[i].classList.add("greyGradient");
      selectorButtons[i].classList.add("fontDefaults");
      if (i === index) // Currently displayed tactic
        selectorButtons[i].classList.replace("greyGradient", `${this.teamColor}Gradient`)
      selectorButtons[i].textContent = `${i + 1} `

      // On click
      selectorButtons[i].addEventListener("click", () => {
        console.log(`clicked tactic selector button ${i + 1} `)
        index = i

        // Highlight the clicked button
        for (let j = 0; j < this.options.length; j++)
          selectorButtons[j].classList.replace(`${this.teamColor}Gradient`, "greyGradient")
        selectorButtons[index].classList.replace("greyGradient", `${this.teamColor}Gradient`)

        // Retrieve and display the associated option description
        option = this.options[index]
        populateMessageButton()
      })
      selectionButtonContainer.appendChild(selectorButtons[i])
    }

    // description of the selected option 
    const optionDescription = document.createElement("div")
    optionDescription.classList.add("explanation");

    // Dialog box title 
    const br = document.createElement("br")
    const recSpan = document.createElement("span")
    const geminiSpark = document.createElement("img")
    geminiSpark.src = '/images/logos/spark_recommend.png'
    geminiSpark.classList.add("geminiSpark")
    let title = document.createElement("div")
    title.classList.add("title")
    let description = document.createElement("div");
    const populateMessageButton = () => {
      title.textContent = option.title
      if (option.index === this.recommendedOptionIndex) {
        title.appendChild(br)
        title.appendChild(geminiSpark)
      }
      description.textContent = option.text;
    }
    populateMessageButton()

    // Add description to the parent element 
    optionDescription.appendChild(title)
    optionDescription.appendChild(description);
    this.element.appendChild(optionDescription)

    // Button to accept the currently displayed tactic.
    const ackButton = document.createElement("div")
    ackButton.classList.add("acceptButton")
    ackButton.textContent = "Accept"
    this.element.appendChild(ackButton)

    // add everything to the DOM 
    this.parent.appendChild(this.element)
  }
}

export default OptionSelection;