// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

import "alpinejs"

import interact from "interactjs"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
import socket from "./socket"

import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

let Hooks = {}
Hooks.Draggable = {
  mounted() {
    let instance = this

    interact(this.el).draggable({
      onmove(event) {
        instance.pushEvent("moving", {x: event.dx, y: event.dy})
      }
    })
  }
}

Hooks.initModal = {
  mounted() {
    const handleOpenCloseEvent = event => {
      if (event.detail.open === false) {
        this.el.removeEventListener("modal-change", handleOpenCloseEvent)
        this.pushEvent("close-modal", {id: this.el.id})
      }
    }
    this.el.addEventListener("modal-change", handleOpenCloseEvent)
  }
}

Hooks.closeModal = {
  mounted() {
    const modalId = this.el.dataset.modalId
    const el = document.getElementById(modalId)
    const event = new CustomEvent('close-modal');
    el.dispatchEvent(event)
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks: Hooks});
liveSocket.connect()
