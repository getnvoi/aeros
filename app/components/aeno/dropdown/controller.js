import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu", "search", "option", "empty", "trigger"];
  static values = {
    open: { type: Boolean, default: false },
    searchable: { type: Boolean, default: false },
  };

  connect() {
    this.closeOnClickOutside = this.closeOnClickOutside.bind(this);
    this.handleKeydown = this.handleKeydown.bind(this);
    this.positionMenu = this.positionMenu.bind(this);
  }

  disconnect() {
    document.removeEventListener("click", this.closeOnClickOutside);
    document.removeEventListener("keydown", this.handleKeydown);
    window.removeEventListener("scroll", this.positionMenu, true);
    window.removeEventListener("resize", this.positionMenu);
  }

  toggle(event) {
    event.stopPropagation();
    this.openValue ? this.close() : this.open();
  }

  open() {
    this.openValue = true;
    this.menuTarget.classList.remove("hidden");
    this.positionMenu();

    document.addEventListener("click", this.closeOnClickOutside);
    document.addEventListener("keydown", this.handleKeydown);
    window.addEventListener("scroll", this.positionMenu, true);
    window.addEventListener("resize", this.positionMenu);

    if (this.searchableValue && this.hasSearchTarget) {
      this.searchTarget.value = "";
      this.filter();
      setTimeout(() => this.searchTarget.focus(), 0);
    }
  }

  positionMenu() {
    if (!this.hasTriggerTarget) return;

    const triggerRect = this.triggerTarget.getBoundingClientRect();
    const menuRect = this.menuTarget.getBoundingClientRect();

    // Position below trigger, aligned to right
    let top = triggerRect.bottom + 8; // 8px gap (mt-2)
    let left = triggerRect.right - menuRect.width;

    // Ensure menu doesn't go off screen
    if (left < 8) left = 8;
    if (left + menuRect.width > window.innerWidth - 8) {
      left = window.innerWidth - menuRect.width - 8;
    }

    // If menu goes below viewport, show above trigger
    if (top + menuRect.height > window.innerHeight - 8) {
      top = triggerRect.top - menuRect.height - 8;
    }

    this.menuTarget.style.top = `${top}px`;
    this.menuTarget.style.left = `${left}px`;
  }

  close() {
    this.openValue = false;
    this.menuTarget.classList.add("hidden");
    document.removeEventListener("click", this.closeOnClickOutside);
    document.removeEventListener("keydown", this.handleKeydown);
    window.removeEventListener("scroll", this.positionMenu, true);
    window.removeEventListener("resize", this.positionMenu);
  }

  closeOnClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.close();
    }
  }

  handleKeydown(event) {
    if (event.key === "Escape") {
      this.close();
    }
  }

  filter() {
    if (!this.hasSearchTarget || !this.hasOptionTarget) return;

    const query = this.searchTarget.value.toLowerCase().trim();
    let visibleCount = 0;

    this.optionTargets.forEach((option) => {
      const label = option.dataset.label?.toLowerCase() || option.textContent.toLowerCase();
      const matches = query === "" || label.includes(query);

      option.classList.toggle("hidden", !matches);
      if (matches) visibleCount++;
    });

    if (this.hasEmptyTarget) {
      this.emptyTarget.classList.toggle("hidden", visibleCount > 0);
    }
  }

  select(event) {
    const option = event.currentTarget;
    const value = option.dataset.value;
    const label = option.dataset.label || option.textContent.trim();

    console.log("Dropdown select clicked:", { value, label });
    this.dispatch("select", { detail: { value, label, event } });
    console.log("Event dispatched, defaultPrevented:", event.defaultPrevented);

    // Don't close if parent controller prevents default
    if (!event.defaultPrevented) {
      console.log("Closing dropdown");
      this.close();
    } else {
      console.log("Keeping dropdown open");
    }
  }
}
