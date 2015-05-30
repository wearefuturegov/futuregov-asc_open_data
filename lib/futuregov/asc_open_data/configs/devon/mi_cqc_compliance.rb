module Futuregov
  module ASCOpenData
    module Configs
      module Devon
        module MICQCCompliance
          include Common

          FIELD_NAMES = {}

          DELETE_COLUMNS = [
            "new_provider",  # Column is empty
            "carefirst_id_1",  # Redacted
            "carefirst_id_2",  # Redacted
            "organisation_type",  # Column never changes
            "compliant_in_all_areas",  # Redacted
            "non_compliant_in_one_to_two_outcomes",  # Redacted
            "non_compliant_in_three_or_more_outcomes",  # Redacted
            "count"  # Calculated column
          ]

          SMALL_NUMBER_MIN = 8
          SMALL_NUMBER_COLUMNS = [
            "nursing_chc_client_count",
            "all_chc_client_count",
            "domiciliary_chc_client_count",
            "residential_client_count",
            "residential_chc_client_count",
            "all_client_count",
            "%_of_the_registered_beds_we_buy",
            "occupancy"
          ]

          def self.configure!(config)
            config.normalise_headers = HEADER_NORMALISERS[:default].call(FIELD_NAMES)
            config.columns_to_delete = DELETE_COLUMNS
            config.normalisers = {
              "brand_name" => FIELD_NORMALISERS[:null_dashes].merge(
                /^BRAND/ => -> (row, field, value) { row[field] = value.sub("BRAND ", "") }
              ),
              "meets_dcc_quality_threshold" => -> (row, field, value) { row[field] = value[0] }
            }
            config.sanitisers = SMALL_NUMBER_COLUMNS.each_with_object({}) do |col, h|
              h[col] = FIELD_SANITISERS[:small_numbers].call(SMALL_NUMBER_MIN)
            end
          end
        end
      end
    end
  end
end
