module Aeros::Primitives::Table
  class Column < Aeros::ApplicationViewComponent
    erb_template <<~ERB
      <th scope="col" class="cp-table__th <%= css %>"><%= content %></th>
    ERB
  end
end
