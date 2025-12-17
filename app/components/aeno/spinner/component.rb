module Aeno::Spinner
  class Component < ::Aeno::ApplicationViewComponent
    option(:size, default: proc { :default })
    option(:variant, default: proc { :default })
    option(:css, optional: true)

    style do
      base do
        %w[
          relative
          inset-0
          pl-2
          mr-0
          w-5
          h-5
          before:content-['']
          before:box-border
          before:absolute
          before:top-1/2
          before:left-1/2
          before:w-5
          before:h-5
          before:-mt-2
          before:-ml-2
          before:rounded-full
          before:border-2
          before:animate-spin
        ]
      end

      variants do
        size do
          xs { "before:w-3 before:h-3 before:-mt-1.5 before:-ml-1.5" }
          sm { "before:w-4 before:h-4 before:-mt-2 before:-ml-2" }
          default { "before:w-5 before:h-5 before:-mt-2.5 before:-ml-2.5" }
          lg { "before:w-6 before:h-6 before:-mt-3 before:-ml-3" }
          xl { "before:w-8 before:h-8 before:-mt-4 before:-ml-4" }
        end

        variant do
          white { "before:border-white/50 before:border-t-white" }
          default { "before:border-gray-500/50 before:border-t-gray-500" }
          primary { "before:border-default-500/50 before:border-t-default-500" }
          secondary { "before:border-secondary/50 before:border-t-secondary" }
          destructive { "before:border-destructive/50 before:border-t-destructive" }
          black { "before:border-black/50 before:border-t-black" }
        end
      end
    end

    examples("Spinner", description: "Loading indicators") do |b|
      b.example(:default, title: "Default") do |e|
        e.preview
      end

      b.example(:sizes, title: "Sizes") do |e|
        e.preview size: :xs
        e.preview size: :sm
        e.preview size: :default
        e.preview size: :lg
        e.preview size: :xl
      end

      b.example(:variants, title: "Variants") do |e|
        e.preview variant: :default
        e.preview variant: :black
      end
    end

    erb_template <<~ERB
      <span class="<%= style(size:, variant:) %> <%= css %>" data-controller="<%= controller_name %>"></span>
    ERB
  end
end
