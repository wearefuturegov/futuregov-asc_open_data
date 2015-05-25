module Futuregov
  module ASCOpenData
    module Configs
      module Devon
        module HomeVacancies
          include Common

          FIELD_NAMES = {
            "" => "area",
            /carefirst/ => "carefirst_id",
            "telephone_no." => "telephone",
            /email_address/ => "email_address",
            /location_id/ => "cqc_location_id"
          }

          def self.configure!(config)
            config.normalise_headers = HEADER_NORMALISERS[:default].call(FIELD_NAMES)
            config.columns_to_delete = [nil, "carefirst_id"]
            normalise_vacancies = {
              "FULL" => 0,
              /no vacancies/i => 0,
              "See comments" => nil,
              "availability" => nil,
              /.*/ => -> (row, field, value) { row[field] = value.to_i }
            }
            config.normalisers = {
              "contact" => FIELD_NORMALISERS[:trimmer],
              "telephone" => FIELD_NORMALISERS[:trimmer],
              "email_address" => FIELD_NORMALISERS[:trimmer].merge(
                /.*/ => -> (row, field, value) {
                  row[field] = value.split(" ").reject {|v| !v.include?("@") }.join(",")
                }
              ),
              "date_vacancies_were_updated" => {
                "-" => "",
                "NR" => "",
                "N/R" => "",
                "No Reply" => ""
              }.merge(FIELD_NORMALISERS[:convert_dotted_dates]),
              "no_of_residential_vacancies" => normalise_vacancies,
              "no_of_nursing_vacancies" => normalise_vacancies,
              "no_of_short_stay_vacancies" => normalise_vacancies
            }
            config.row_filters = {
              no_cqc_id: -> (row) { row["cqc_location_id"] == nil }
            }
          end
        end
      end
    end
  end
end
