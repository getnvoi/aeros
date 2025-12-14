module Aeros::Primitives::Layouts::App
  class Aside < Aeros::ApplicationViewComponent
    erb_template <<~ERB
      <aside class="cp-layout-app__aside" style="<%= merged_style %>">
        <%= content %>
      </aside>
    ERB
  end
end
