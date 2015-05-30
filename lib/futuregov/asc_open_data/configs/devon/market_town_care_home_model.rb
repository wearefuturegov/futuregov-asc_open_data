module Futuregov
  module ASCOpenData
    module Configs
      module Devon
        module MarketTownCareHomeModel
          include Common

          FIELD_NAMES = {}

          SMALL_NUMBER_MIN = 8
          SMALL_NUMBER_COLUMNS = [
            7, 8, 9, 10, 11, 12, 13, 15, 16, 17
          ]

          def self.configure!(config)
            config.row_filters[:remove_title] = -> (row) { row.length == 1 }
            config.sanitisers = SMALL_NUMBER_COLUMNS.each_with_object({}) do |col, h|
              h[col] = FIELD_SANITISERS[:small_numbers].call(SMALL_NUMBER_MIN)
            end
          end
        end
      end
    end
  end
end
