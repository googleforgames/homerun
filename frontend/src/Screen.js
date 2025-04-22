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

import { Sprite, Container } from "pixi.js"

// Screen is the abstraction for displaying a background image in the baseball game, and 
// drawing clickable windows on top of it. It can draw the clickable windows created by
// the 'optionSelection' and 'coach' classes.
class Screen {
  constructor(config) {
    // screen background config
    this.w = config.width || 100
    this.h = config.height || 100
    this.scale = config.scale || 1.0
    this.initialAlpha = config.initialAlpha
    this.backgroundAssetAlias = config.backgroundAssetAlias || "background"

    // Screen sprite asset config
    this.assetBundle = config.assetBundle

    // Pixi stage and a container to add this screen and it's sprites to
    this.stage = config.stage
    this.container = new Container()

    // UI gets its own container as it doesn't fade in and out with the rest of the sprites.
    this.uiContainer = new Container()

    // Function to call when finishing an animation
    this.resolve = config.resolve

    // Div in which to add DOM elements
    this.gameDiv = config.gameDiv
    this.buttonIdle = config.buttonIdle

    // Storage of sprites that are currently displayed on this screen
    this.children = new Map()
  }

  // The idle state never resolves; the screen will remain in this state until
  // something else resolves this idle animation state, marking it as complete
  // and moving to the next animation in the global update queue.
  idle(deltaTime, update) {
    this.elapsed += deltaTime
  }

  dirty(deltaTime, update) {
    this.idle(deltaTime, update)
  }

  fadeOut(deltaTime, update) {
    //console.log("in fadeOut, removing buttons")
    if (Array.isArray(this.children)) {
      for (const child of this.children) { this.stage.removeChild(child.container) }
    }
    //console.log("in fadeOut, alpha " + this.container.alpha)
    this.container.alpha = this.container.alpha - (0.01 * deltaTime)
    if (this.container.alpha <= 0.0) {
      // This animation is complete, 'resolve' the animation state transition.
      this.resolve()
    }
  }

  fadeIn(deltaTime, update) {
    this.container.alpha = this.container.alpha + (0.01 * deltaTime)
    //console.log("this.bg.alpha:" + this.bg.alpha)
    if (this.container.alpha >= 1.0) {
      // This animation is complete, 'resolve' the animation state transition.
      this.resolve()
    }
  }

  // Display the options the player can choose from.
  displayOptionSelection(deltatime, display) {
    // We only want to initialize the option selection buttons once. So, as soon
    // as a 'displayOptionSelection' animation state is requested, remove it and
    // replace it with an 'idle' animation that will be removed by the resolve()
    // callback
    this.buttonIdle()

    display.optionSelection.display(this.gameDiv, () => {
      this.resolve()
    })
  }

  // Display coach tutorial  
  displayGeminiCoach(deltatime, display) {
    // Same as displaying an option selection; immediately remove this state and
    // replace with an idle state
    this.buttonIdle()

    display.coach.display(this.gameDiv, () => {
      this.resolve()
    })
  }

  removeChild(spriteName, ui) {
    console.log(` screen.removeChild '${spriteName}'`)
    try {
      if (ui)
        this.uiContainer.removeChild(this.children.get(spriteName))
      else
        this.container.removeChild(this.children.get(spriteName))
      this.children.delete(spriteName)
      console.log(`removed sprite ${spriteName}`)
    } catch (error) {
      console.log(`unable to remove sprite ${spriteName}: ${error}`)
    }
  }

  addChildShape(shape, shapeName) {
    this.uiContainer.addChild(shape)
    // this.stage.addChild(shape)
    this.children.set(shapeName, shape)
  }

  addChildSprite(spriteName, textureProperties, ui) {
    // get sprite and sprite properties 
    let child = new Sprite(this.assetBundle[spriteName])
    child.alpha = textureProperties.alpha || 1.0
    child.x = textureProperties.x || 0
    child.y = textureProperties.y || 0
    console.log(` initializing sprite '${spriteName}': x:${textureProperties.x} y:${textureProperties.y} scale:${textureProperties.scale} `)
    child.scale.set(textureProperties.scale || 1.0)

    console.log(`adding new sprite ${spriteName}`)

    // actually add to the app.stage 
    if (ui)
      this.uiContainer.addChild(child)
    else
      this.container.addChild(child)
    this.children.set(spriteName, child)
  }

  addTo(stage) {
    // elapsed time
    this.elapsed = 0

    // sprite to hold the bg image
    this.bg = new Sprite(this.assetBundle[this.backgroundAssetAlias])
    // this.container.alpha = this.initialAlpha
    this.container.alpha = 0.0
    console.log("intialized screen, set initial alpha to " + this.container.alpha)

    // actually add to the canvas
    this.container.addChild(this.bg)
    this.stage = stage
    this.stage.addChild(this.container)
    this.stage.addChild(this.uiContainer)
  }


  // Just a basic interceptor for the desired animation update call that also
  // executes the same animation update for all children attached to this
  // screen.
  update(deltaTime, display) {
    // Run an update for the current screen's animation state.
    // This line resolves to calling the class method whose name is held in the updateQueue[index)."animation" value.
    this[display.animation](deltaTime, display)
  }

  remove() {
    this.container.removeChildren()
    this.stage.removeChild(this.container)
    console.log("reaped")
  }
}

export default Screen