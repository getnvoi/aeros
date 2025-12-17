module Aeno::Table
  class Component < ::Aeno::ApplicationViewComponent
    option(:css, optional: true)
    option(:id, optional: true)

    renders_one :header, "HeaderComponent"
    renders_many :rows, "RowComponent"

    class HeaderComponent < Aeno::ApplicationViewComponent
      renders_many :columns, "ColumnComponent"

      class ColumnComponent < Aeno::ApplicationViewComponent
        option(:css, optional: true)

        erb_template <<~ERB
          <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider <%= css %>">
            <%= content %>
          </th>
        ERB
      end

      erb_template <<~ERB
        <thead class="bg-gray-50">
          <tr>
            <% columns.each do |column| %>
              <%= column %>
            <% end %>
          </tr>
        </thead>
      ERB
    end

    class RowComponent < Aeno::ApplicationViewComponent
      option(:css, optional: true)

      renders_many :cells, "CellComponent"

      class CellComponent < Aeno::ApplicationViewComponent
        option(:css, optional: true)

        erb_template <<~ERB
          <td class="px-6 py-4 text-sm text-gray-900 <%= css %>">
            <%= content %>
          </td>
        ERB
      end

      erb_template <<~ERB
        <tr class="<%= css %>">
          <% cells.each do |cell| %>
            <%= cell %>
          <% end %>
        </tr>
      ERB
    end

    def table_classes
      [
        "min-w-full divide-y divide-gray-200",
        css
      ].compact.join(" ")
    end

    examples("Table", description: "Data table") do |b|
      b.example(:default, title: "Default") do |e|
        e.preview do |table|
          table.with_header do |h|
            h.with_column { "Name" }
            h.with_column { "Email" }
          end
          table.with_row do |r|
            r.with_cell { "John Doe" }
            r.with_cell { "john@example.com" }
          end
          table.with_row do |r|
            r.with_cell { "Jane Smith" }
            r.with_cell { "jane@example.com" }
          end
        end
      end
    end
  end
end

