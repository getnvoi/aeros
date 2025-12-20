# frozen_string_literal: true

module Aeno::Input::Otp
  class Component < ::Aeno::FormBuilder::BaseComponent
    option(:length, default: proc { 6 })
    option(:pattern, default: proc { "[0-9]*" })
    option(:autocomplete, default: proc { "one-time-code" })
    option(:inputmode, default: proc { "numeric" })
    option(:separator, optional: true)
    option(:separator_every, default: proc { 3 })
    option(:autosubmit, default: proc { false })

    # Generate array of input IDs for targets
    def input_ids
      (0...length).map { |i| "#{id}_#{i}" }
    end

    # Stimulus values to pass to controller
    def stimulus_values
      {
        "#{controller_name}-length-value" => length,
        "#{controller_name}-pattern-value" => pattern,
        "#{controller_name}-autosubmit-value" => autosubmit
      }
    end

    # Check if separator should be rendered after this index
    def show_separator_after?(index)
      separator &&
        (index + 1) < length &&
        ((index + 1) % separator_every).zero?
    end

    examples("Input OTP", description: "One-time password input field") do |b|
      b.example(:default, title: "Default 6-digit") do |e|
        e.preview name: "verification_code", label: "Verification Code"
      end

      b.example(:four_digit, title: "4-digit PIN") do |e|
        e.preview name: "pin", length: 4, label: "PIN Code"
      end

      b.example(:with_separator, title: "With separator") do |e|
        e.preview name: "code", length: 6, separator: "-", separator_every: 3, label: "Code"
      end

      b.example(:autosubmit, title: "Auto-submit enabled") do |e|
        e.preview name: "code", autosubmit: true, label: "Enter Code"
      end
    end
  end
end
