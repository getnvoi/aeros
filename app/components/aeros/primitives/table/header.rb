module Aeros::Primitives::Table
  class Header < Aeros::ApplicationViewComponent
    renders_many :columns, Aeros::Primitives::Table::Column

    erb_template <<~ERB
      <thead class="cp-table__head">
        <tr>
          <% columns.each do |column| %><%= column %><% end %>
        </tr>
      </thead>
    ERB
  end
end
