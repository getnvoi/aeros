import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "button", "iconOpen", "iconClose"]

  connect() {
    this.isOpen = false
  }

  toggle() {
    this.isOpen ? this.close() : this.open()
  }

  open() {
    this.isOpen = true
    this.panelTarget.classList.remove("scale-0", "opacity-0")
    this.panelTarget.classList.add("scale-100", "opacity-100")

    if (this.hasIconOpenTarget && this.hasIconCloseTarget) {
      this.iconOpenTarget.classList.add("hidden")
      this.iconCloseTarget.classList.remove("hidden")
    }

    if (this.hasButtonTarget) {
      this.buttonTarget.classList.add("rotate-90")
    }
  }

  close() {
    this.isOpen = false
    this.panelTarget.classList.add("scale-0", "opacity-0")
    this.panelTarget.classList.remove("scale-100", "opacity-100")

    if (this.hasIconOpenTarget && this.hasIconCloseTarget) {
      this.iconOpenTarget.classList.remove("hidden")
      this.iconCloseTarget.classList.add("hidden")
    }

    if (this.hasButtonTarget) {
      this.buttonTarget.classList.remove("rotate-90")
    }
  }
}
