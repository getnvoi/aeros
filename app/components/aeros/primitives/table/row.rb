module Aeros::Primitives::Table
  class Row < Aeros::ApplicationViewComponent
    renders_many :cells, Aeros::Primitives::Table::Cell

    erb_template <<~ERB
      <tr class="cp-table__tr <%= css %>">
        <% cells.each do |cell| %><%= cell %><% end %>
      </tr>
    ERB
  end
end
