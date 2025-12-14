module Aeros::Primitives::Table
  class Cell < Aeros::ApplicationViewComponent
    erb_template <<~ERB
      <td class="cp-table__td <%= css %>"><%= content %></td>
    ERB
  end
end
