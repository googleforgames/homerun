# Home Run OSS Repository 

This is the repository for the open source portions of the Google Cloud GenAI game demo "Home Run: Gemini Coach Edition" HTML frontend.  The client is a javascript Pixi.js project, and in order to run it locally, you will need `npm` installed, then follow these steps:

* The client in this repository uses [GenAI quickstart with SmartNPC](https://github.com/googleforgames/GenAI-quickstart) as the game backend.  Follow the instructions in that repo to set up the `GenAI quickstart with SmartNPC` using Terraform. Make note of the following values.
  * `APIURL`, and `WSURL` will be provided to you in the console output.
  * `APIKEY` is generated and stored in `config.toml` in the `SmartNPC` example folder.

* clone this repository, and replace the `APIKEY`, `APIURL`, and `WSURL` variables at the top of the `src/Game.js` file with the values you got from standing up the backend.  If you haven't populated these values, you will receive a `Uncaught Error: Unable to start without API key and backend endpoints` error in your browser developer tools console.

* set up the dependencies using NPM:
  ```
  npm install
  npm run dev
  ```
* Use your browser of choice to connect to the client at the address provided by `npm run dev` (typically [http://localhost:8080/]()).

You can view the logs from the client using your browser's developer tools.

## Additional Information
This project is intended for demonstration purposes only. It is not
intended for use in a production environment.

This is not an officially supported Google product. This project is not
eligible for the [Google Open Source Software Vulnerability Rewards
Program](https://bughunters.google.com/open-source-security).