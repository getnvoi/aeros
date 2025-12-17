import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["hiddenInputs"];
  static values = {
    multiple: { type: Boolean, default: false },
    name: String,
  };

  connect() {
    console.log("SelectDropdown connected, multiple:", this.multipleValue);
    // Initialize visual state on page load
    if (this.multipleValue) {
      this.updateButtonLabel();
      this.updateSelectionVisuals();
    }
  }

  select(event) {
    console.log("SelectDropdown select received:", event);
    const detail = event.detail;
    const value = detail.value;
    const label = detail.label;
    const originalEvent = detail.event;

    console.log("Multiple mode:", this.multipleValue, "Value:", value);

    if (this.multipleValue) {
      console.log("Preventing default to keep dropdown open");
      // Prevent dropdown from closing for multiple select
      originalEvent.preventDefault();
      this.toggleMultiple(value);
    } else {
      console.log("Single mode - calling selectSingle");
      this.selectSingle(value);
    }

    this.dispatch("change", { detail: { value, label, multiple: this.multipleValue } });
  }

  selectSingle(value) {
    console.log("selectSingle called with value:", value);
    // Clear existing hidden inputs
    this.hiddenInputsTarget.innerHTML = "";

    // Create new hidden input
    const input = document.createElement("input");
    input.type = "hidden";
    input.name = this.nameValue;
    input.value = value;
    this.hiddenInputsTarget.appendChild(input);
    console.log("Hidden input created:", input);

    // Update button label
    const dropdown = this.element.querySelector("[data-controller='aeno--dropdown']");
    if (dropdown) {
      const button = dropdown.querySelector("button");
      const selectedOption = Array.from(dropdown.querySelectorAll("[role='menuitem']"))
        .find(opt => opt.dataset.value === value);
      if (button && selectedOption) {
        const labelElement = button.querySelector('[data-role="label"]');
        if (labelElement) {
          console.log("Updating button label to:", selectedOption.dataset.label);
          labelElement.textContent = selectedOption.dataset.label;
        }
      }
    }
  }

  toggleMultiple(value) {
    console.log("toggleMultiple called with value:", value);
    const existingInputs = Array.from(
      this.hiddenInputsTarget.querySelectorAll("input[type='hidden']")
    );
    const existingInput = existingInputs.find(input => input.value === value);

    if (existingInput) {
      // Remove if already selected
      existingInput.remove();
    } else {
      // Add if not selected
      const input = document.createElement("input");
      input.type = "hidden";
      input.name = `${this.nameValue}[]`;
      input.value = value;
      this.hiddenInputsTarget.appendChild(input);
    }

    // Update button label with selected values
    this.updateButtonLabel();

    // Update selected state visual
    this.updateSelectionVisuals();
  }

  updateButtonLabel() {
    console.log("updateButtonLabel called");
    const dropdown = this.element.querySelector("[data-controller='aeno--dropdown']");
    console.log("Dropdown element:", dropdown);
    if (!dropdown) return;

    const button = dropdown.querySelector("button");
    console.log("Button element:", button);
    const labelElement = button?.querySelector("span.truncate");
    console.log("Label element:", labelElement);
    if (!labelElement) return;

    if (this.multipleValue) {
      const selectedValues = Array.from(
        this.hiddenInputsTarget.querySelectorAll("input[type='hidden']")
      ).map(input => input.value);
      console.log("Selected values:", selectedValues);

      if (selectedValues.length === 0) {
        console.log("No values selected, setting to 'Select...'");
        labelElement.textContent = "Select...";
      } else {
        const options = dropdown.querySelectorAll("[role='menuitem']");
        const selectedLabels = Array.from(options)
          .filter(opt => selectedValues.includes(opt.dataset.value))
          .map(opt => opt.dataset.label);
        console.log("Selected labels:", selectedLabels);

        let newText;
        if (selectedLabels.length <= 2) {
          newText = selectedLabels.join(", ");
        } else {
          const remaining = selectedLabels.length - 2;
          newText = `${selectedLabels.slice(0, 2).join(", ")} (+${remaining})`;
        }
        console.log("Setting button label to:", newText);
        labelElement.textContent = newText;
      }
    }
  }

  updateSelectionVisuals() {
    const selectedValues = Array.from(
      this.hiddenInputsTarget.querySelectorAll("input[type='hidden']")
    ).map(input => input.value);

    const dropdown = this.element.querySelector("[data-controller='aeno--dropdown']");
    if (dropdown) {
      const options = dropdown.querySelectorAll("[role='menuitem']");
      options.forEach(option => {
        const isSelected = selectedValues.includes(option.dataset.value);
        option.classList.toggle("bg-gray-50", isSelected);

        // Update icon to reflect selection state
        const iconContainer = option.querySelector("svg");
        if (iconContainer && this.multipleValue) {
          // For multiple select, swap between square and check-square icons
          option.dataset.icon = isSelected ? "check-square" : "square";
          this.updateOptionIcon(option, isSelected ? "check-square" : "square");
        }
      });
    }
  }

  updateOptionIcon(option, iconName) {
    const iconContainer = option.querySelector("div");
    if (!iconContainer) return;

    const svg = iconContainer.querySelector("svg");
    if (!svg) return;

    // Icon SVG paths for different states
    const icons = {
      "square": '<rect width="18" height="18" x="3" y="3" rx="2"></rect>',
      "check-square": '<path d="m9 11 3 3L22 4"></path><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>',
      "circle": '<circle cx="12" cy="12" r="10"></circle>',
      "circle-dot": '<circle cx="12" cy="12" r="10"></circle><circle cx="12" cy="12" r="1"></circle>'
    };

    if (icons[iconName]) {
      svg.innerHTML = icons[iconName];
    }
  }
}
