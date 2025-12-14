module Aeros::Primitives::Table
  class Component < ::Aeros::ApplicationViewComponent
    option(:id, optional: true)

    renders_one :header, Aeros::Primitives::Table::Header
    renders_many :rows, Aeros::Primitives::Table::Row
  end
end
