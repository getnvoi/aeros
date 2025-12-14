module Aeros::Primitives::Card
  class Component < ::Aeros::ApplicationViewComponent
    option(:css, optional: true)
    option(:variant, default: proc { :default })
    option(:padding, default: proc { true })

    style do
      base { "bg-card-bg border border-card-border text-card-text rounded-card shadow-card" }

      variants do
        padding do
          yes { "p-6" }
          no { "" }
        end

        variant do
          default { "" }
          ghost { "border-transparent shadow-none bg-transparent" }
          elevated { "shadow-lg" }
        end
      end
    end

    def classes
      [css, style(padding:, variant:)].compact.join(" ")
    end

    erb_template <<~ERB
      <div class="<%= classes %>">
        <%= content %>
      </div>
    ERB
  end
end
