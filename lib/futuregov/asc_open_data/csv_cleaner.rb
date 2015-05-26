require "csv"

module Futuregov
  module ASCOpenData
    class CSVCleaner
      attr_reader :csv, :table
      attr_accessor :config

      class Config
        attr_accessor :normalise_headers,
          :columns_to_delete,
          :row_filters,
          :normalisers,
          :sanitisers

        def initialize
          @normalise_headers = {}
          @columns_to_delete = {}
          @row_filters = {}
          @normalisers = {}
          @sanitisers = {}
        end
      end

      def initialize(csv, config)
        @csv = csv
        @config = config
      end

      def clean!
        csv.header_convert(&config.normalise_headers)

        @table = csv.read

        delete_columns(config.columns_to_delete)
        filter_rows(config.row_filters)
        normalise_rows(config.normalisers)
        sanitise_rows(config.sanitisers)
      end

      def delete_columns(names)
        names.each {|name| table.delete(name) }
      end

      def normalise_rows(normalisers)
        table.each do |row|
          normalise_row(row, normalisers)
        end
      end

      def normalise_row(row, normalisers)
        row.each do |field, value|
          normaliser = normalisers[field]
          next if normaliser.nil?
          normaliser.each do |k, action|
            if k === value
              if action.nil?
                row[field] = nil
              elsif String === action
                row[field] = action 
              elsif Proc === action 
                row[field] = action.call(row, field, value)
              end
            end
          end
        end
      end

      def sanitise_rows(sanitisers)
        table.each do |row|
          sanitisers.each do |col, method|
            row[col] = method.call(row, col, row[col])
          end
        end
      end

      def filter_rows(filters)
        filters.each do |_, filter|
          table.delete_if(&filter)
        end
      end
    end
  end
end
