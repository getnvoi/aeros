import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "hiddenInput"];

  static values = {
    length: { type: Number, default: 6 },
    pattern: { type: String, default: "[0-9]*" },
    autosubmit: { type: Boolean, default: false }
  };

  connect() {
    // Convert pattern string to regex
    this.patternRegex = createPatternRegex(this.patternValue);

    // Pre-fill from hidden input if value exists
    if (this.hiddenInputTarget.value) {
      this.populateFromValue(this.hiddenInputTarget.value);
    }
  }

  // Handle single character input
  handleInput(event) {
    const input = event.target;
    const index = this.getInputIndex(input);
    let value = input.value;

    // Validate against pattern
    if (value && !this.isValidCharacter(value.slice(-1))) {
      input.value = "";
      return;
    }

    // Take only the last character if multiple were entered
    if (value.length > 1) {
      value = value.slice(-1);
      input.value = value;
    }

    // Update hidden input
    this.updateHiddenInput();

    // Auto-advance to next input
    if (value && index < this.lengthValue - 1) {
      this.focusInput(index + 1);
    }

    // Dispatch event and auto-submit when complete
    if (this.isComplete()) {
      this.dispatch("complete", {
        detail: { value: this.getValue() }
      });

      if (this.autosubmitValue) {
        const form = this.element.closest('form');
        if (form) {
          form.requestSubmit();
        }
      }
    }
  }

  // Handle keyboard navigation and deletion
  handleKeydown(event) {
    const input = event.target;
    const index = this.getInputIndex(input);

    switch (event.key) {
      case "Backspace":
        if (!input.value && index > 0) {
          // Move to previous input if current is empty
          event.preventDefault();
          this.focusInput(index - 1);
          this.inputTargets[index - 1].value = "";
          this.updateHiddenInput();
        }
        break;

      case "Delete":
        input.value = "";
        this.updateHiddenInput();
        break;

      case "ArrowLeft":
        event.preventDefault();
        if (index > 0) this.focusInput(index - 1);
        break;

      case "ArrowRight":
        event.preventDefault();
        if (index < this.lengthValue - 1) this.focusInput(index + 1);
        break;

      case "Home":
        event.preventDefault();
        this.focusInput(0);
        break;

      case "End":
        event.preventDefault();
        this.focusInput(this.lengthValue - 1);
        break;

      // Prevent non-matching input for all patterns
      default:
        if (event.key.length === 1 && !this.isValidCharacter(event.key)) {
          event.preventDefault();
        }
    }
  }

  // Handle paste functionality
  handlePaste(event) {
    event.preventDefault();

    const pastedData = event.clipboardData.getData("text");
    const sanitized = this.sanitizeValue(pastedData);

    if (sanitized.length > 0) {
      this.populateFromValue(sanitized);
      this.updateHiddenInput();

      // Focus last filled input or first empty
      const focusIndex = Math.min(sanitized.length, this.lengthValue - 1);
      this.focusInput(focusIndex);

      if (this.isComplete()) {
        this.dispatch("complete", {
          detail: { value: this.getValue() }
        });

        if (this.autosubmitValue) {
          const form = this.element.closest('form');
          if (form) {
            form.requestSubmit();
          }
        }
      }
    }
  }

  // Handle focus to select all
  handleFocus(event) {
    event.target.select();
  }

  // Populate inputs from a string value
  populateFromValue(value) {
    const sanitized = this.sanitizeValue(value);
    this.inputTargets.forEach((input, index) => {
      input.value = sanitized[index] || "";
    });
  }

  // Sanitize and validate value
  sanitizeValue(value) {
    return sanitizeValue(value, this.patternRegex, this.lengthValue);
  }

  // Check if character matches pattern
  isValidCharacter(char) {
    return isValidCharacter(char, this.patternRegex);
  }

  // Get complete OTP value
  getValue() {
    return this.inputTargets
      .map(input => input.value)
      .join("");
  }

  // Check if all inputs are filled
  isComplete() {
    return this.getValue().length === this.lengthValue;
  }

  // Update hidden input with current value
  updateHiddenInput() {
    this.hiddenInputTarget.value = this.getValue();
    this.dispatch("change", {
      detail: { value: this.getValue() }
    });
  }

  // Focus input at specific index
  focusInput(index) {
    if (this.inputTargets[index]) {
      this.inputTargets[index].focus();
    }
  }

  // Get index of input element
  getInputIndex(input) {
    return this.inputTargets.indexOf(input);
  }

  // Public method to clear all inputs
  clear() {
    this.inputTargets.forEach(input => input.value = "");
    this.hiddenInputTarget.value = "";
    this.focusInput(0);
  }

  // Public method to set value programmatically
  setValue(value) {
    this.populateFromValue(value);
    this.updateHiddenInput();
  }
}

// Export helper functions for testing
export function sanitizeValue(value, patternRegex, length) {
  return value
    .split("")
    .filter(char => patternRegex.test(char))
    .slice(0, length)
    .join("");
}

export function isValidCharacter(char, patternRegex) {
  return patternRegex.test(char);
}

export function createPatternRegex(pattern) {
  // Remove asterisk if present (we only care about single character matching)
  const patternStr = pattern.replace(/\*$/g, '');
  // If pattern already has brackets, use as is; otherwise wrap in brackets
  const regex = patternStr.startsWith('[') ? `^${patternStr}$` : `^[${patternStr}]$`;
  return new RegExp(regex);
}
