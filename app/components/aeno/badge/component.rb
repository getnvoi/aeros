# frozen_string_literal: true

module Aeno
  module Badge
    class Component < Aeno::ApplicationViewComponent
      option :label
      option :variant, default: -> { :gray }
      option :css, optional: true

      def variant_classes
        case variant
        when :red
          "bg-red-100 text-red-700 dark:bg-red-400/10 dark:text-red-400"
        when :yellow
          "bg-yellow-100 text-yellow-800 dark:bg-yellow-400/10 dark:text-yellow-500"
        when :green
          "bg-green-100 text-green-700 dark:bg-green-400/10 dark:text-green-400"
        when :blue
          "bg-blue-100 text-blue-700 dark:bg-blue-400/10 dark:text-blue-400"
        when :indigo
          "bg-indigo-100 text-indigo-700 dark:bg-indigo-400/10 dark:text-indigo-400"
        when :purple
          "bg-purple-100 text-purple-700 dark:bg-purple-400/10 dark:text-purple-400"
        when :pink
          "bg-pink-100 text-pink-700 dark:bg-pink-400/10 dark:text-pink-400"
        else # :gray
          "bg-gray-100 text-gray-600 dark:bg-gray-400/10 dark:text-gray-400"
        end
      end

      def classes
        [
          "inline-flex items-center rounded-md px-2 py-1 text-xs font-medium",
          variant_classes,
          css
        ].compact.join(" ")
      end

      examples("Badge", description: "Small status indicators and labels") do |b|
        b.example(:default, title: "Default") do |e|
          e.preview label: "Badge"
        end

        b.example(:variants, title: "Variants") do |e|
          e.preview variant: :gray, label: "Badge"
          e.preview variant: :red, label: "Badge"
          e.preview variant: :yellow, label: "Badge"
          e.preview variant: :green, label: "Badge"
          e.preview variant: :blue, label: "Badge"
          e.preview variant: :indigo, label: "Badge"
          e.preview variant: :purple, label: "Badge"
          e.preview variant: :pink, label: "Badge"
        end
      end
    end
  end
end
