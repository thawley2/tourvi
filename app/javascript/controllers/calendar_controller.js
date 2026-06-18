import { Controller } from "@hotwired/stimulus"

// Drag a tour chip onto a day cell to change its date.
export default class extends Controller {
  static values = { url: String }

  start(event) {
    this.draggingId = event.target.closest("[data-tour-id]").dataset.tourId
    event.dataTransfer.effectAllowed = "move"
  }

  allow(event) {
    event.preventDefault()
  }

  drop(event) {
    event.preventDefault()
    const date = event.currentTarget.dataset.date
    if (!this.draggingId || !date) return

    const token = document.querySelector('meta[name="csrf-token"]')?.content
    fetch(this.urlValue.replace("ID", this.draggingId), {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": token,
        "Accept": "text/vnd.turbo-stream.html, text/html"
      },
      body: JSON.stringify({ tour: { tour_date: date } })
    }).then(() => {
      this.draggingId = null
      window.location.reload()
    })
  }
}
