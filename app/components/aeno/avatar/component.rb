# frozen_string_literal: true

module Aeno
  module Avatar
    class Component < Aeno::ApplicationViewComponent
      option :alt, optional: true
      option :src, optional: true
      option :size, default: -> { :md }
      option :status, optional: true
      option :status_position, default: -> { :top_right }

      style do
        base do
          %w[
            rounded-full
            outline
            -outline-offset-1
            outline-black/5
            dark:outline-white/10
          ]
        end

        variants do
          size do
            xs { "size-6" }
            sm { "size-8" }
            md { "size-10" }
            lg { "size-12" }
            xl { "size-14" }
            xxl { "size-16" }
          end
        end
      end

      def avatar_classes
        style(size:)
      end

      def initials_classes
        [
          style(size:),
          "flex items-center justify-center text-white font-semibold select-none"
        ].join(" ")
      end

      # Extract initials from alt text (max 3 letters)
      def initials
        return "?" unless alt.present?

        words = alt.strip.split(/\s+/)
        words.first(3).map { |word| word[0].upcase }.join
      end

      # Generate deterministic hex color from alt text
      def background_color
        return "#6B7280" unless alt.present? # Default gray if no alt

        # Hash the alt text to get a number
        hash = alt.chars.sum(&:ord)

        # Generate hue (0-360)
        hue = hash % 360

        # Fixed saturation and lightness for good, accessible colors
        saturation = 65
        lightness = 50

        hsl_to_hex(hue, saturation, lightness)
      end

      # Status dot size mapping based on avatar size
      def status_dot_size
        {
          xs: "size-1.5",
          sm: "size-2",
          md: "size-2.5",
          lg: "size-3",
          xl: "size-3.5",
          xxl: "size-4"
        }[size]
      end

      # Status dot color classes
      def status_dot_color_classes
        case status&.to_sym
        when :gray
          "bg-gray-300 dark:bg-gray-500"
        when :red
          "bg-red-400 dark:bg-red-500"
        when :green
          "bg-green-400 dark:bg-green-500"
        when :yellow
          "bg-yellow-400 dark:bg-yellow-500"
        when :blue
          "bg-blue-400 dark:bg-blue-500"
        else
          "bg-gray-300 dark:bg-gray-500"
        end
      end

      # Status dot position classes
      def status_dot_position_classes
        case status_position.to_sym
        when :top_right
          "top-0 right-0"
        when :top_left
          "top-0 left-0"
        when :bottom_right
          "bottom-0 right-0"
        when :bottom_left
          "bottom-0 left-0"
        else
          "top-0 right-0"
        end
      end

      def status_dot_classes
        [
          "absolute block rounded-full ring-2 ring-white dark:ring-gray-900",
          status_dot_size,
          status_dot_color_classes,
          status_dot_position_classes
        ].join(" ")
      end

      def font_size_class
        {
          xs: "text-[9px]",
          sm: "text-[10px]",
          md: "text-xs",
          lg: "text-sm",
          xl: "text-base",
          xxl: "text-lg"
        }[size]
      end

      examples("Avatar", description: "User avatar with image or initials") do |b|
        b.example(:images, title: "Image Avatars - All Sizes") do |e|
          e.preview size: :xs, src: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80", alt: "John Doe"
          e.preview size: :sm, src: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80", alt: "John Doe"
          e.preview size: :md, src: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80", alt: "John Doe"
          e.preview size: :lg, src: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80", alt: "John Doe"
          e.preview size: :xl, src: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80", alt: "John Doe"
          e.preview size: :xxl, src: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80", alt: "John Doe"
        end

        b.example(:status_dots, title: "With Status Dots") do |e|
          e.preview size: :xs, src: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80", alt: "John Doe", status: :gray
          e.preview size: :sm, src: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80", alt: "John Doe", status: :red
          e.preview size: :md, src: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80", alt: "John Doe", status: :green
          e.preview size: :lg, src: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80", alt: "John Doe", status: :gray
          e.preview size: :xl, src: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80", alt: "John Doe", status: :red
          e.preview size: :xxl, src: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80", alt: "John Doe", status: :green
        end

        b.example(:initials, title: "Initials (No Image)") do |e|
          e.preview size: :xs, alt: "John Doe"
          e.preview size: :sm, alt: "Mary Jane Watson"
          e.preview size: :md, alt: "Alexander Hamilton"
          e.preview size: :lg, alt: "Sarah"
          e.preview size: :xl, alt: "Bob Smith"
          e.preview size: :xxl, alt: "Alice Johnson"
        end

        b.example(:initials_with_status, title: "Initials with Status") do |e|
          e.preview size: :sm, alt: "John Doe", status: :gray
          e.preview size: :md, alt: "Mary Jane", status: :red
          e.preview size: :lg, alt: "Alex Smith", status: :green
          e.preview size: :xl, alt: "Sarah Connor", status: :yellow
          e.preview size: :xxl, alt: "Bob Builder", status: :blue
        end

        b.example(:status_colors, title: "Status Colors") do |e|
          e.preview size: :md, src: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80", alt: "Gray", status: :gray
          e.preview size: :md, src: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80", alt: "Red", status: :red
          e.preview size: :md, src: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80", alt: "Green", status: :green
          e.preview size: :md, src: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80", alt: "Yellow", status: :yellow
          e.preview size: :md, src: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80", alt: "Blue", status: :blue
        end

        b.example(:dynamic_colors, title: "Dynamic Colors from Names") do |e|
          e.preview size: :lg, alt: "Alice Anderson"
          e.preview size: :lg, alt: "Bob Builder"
          e.preview size: :lg, alt: "Charlie Chen"
          e.preview size: :lg, alt: "Diana Davis"
          e.preview size: :lg, alt: "Edward Ellis"
          e.preview size: :lg, alt: "Fiona Foster"
        end
      end

      private

      # Convert HSL to Hex color
      def hsl_to_hex(h, s, l)
        h = h.to_f
        s = s.to_f / 100
        l = l.to_f / 100

        c = (1 - (2 * l - 1).abs) * s
        x = c * (1 - ((h / 60.0) % 2 - 1).abs)
        m = l - c / 2

        r, g, b = if h < 60
          [c, x, 0]
        elsif h < 120
          [x, c, 0]
        elsif h < 180
          [0, c, x]
        elsif h < 240
          [0, x, c]
        elsif h < 300
          [x, 0, c]
        else
          [c, 0, x]
        end

        r = ((r + m) * 255).round
        g = ((g + m) * 255).round
        b = ((b + m) * 255).round

        "#%02x%02x%02x" % [r, g, b]
      end
    end
  end
end
