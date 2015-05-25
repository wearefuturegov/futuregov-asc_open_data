module Futuregov
  module ASCOpenData
    module Configs
      module Devon
        module HomeVacancies
          FIELD_NAMES = {
            "" => "area",
            /carefirst/ => "carefirst_id",
            "telephone_no." => "telephone",
            /email_address/ => "email_address",
            /location_id/ => "cqc_location_id"
          }

          def self.configure!(config)
            config.normalise_headers = -> (field, field_info) do
              converted = field.downcase.gsub(' ', '_')
              FIELD_NAMES.each do |key, value|
                converted = value if key === converted
              end
              converted
            end

            config.columns_to_delete = [nil, "carefirst_id"]
            trimmer = {
              /.*/ => -> (row, field, value) { row[field] = value.strip }
            }
            join_spaces = {
              /.*/ => -> (row, field, value) { row[field] = value.split(" ").join(",") }
            }
            convert_dotted_dates = {
              /([0-9]{2})\.([0-9]{2})\.([0-9]{2})/ => -> (row, field, value) {
                row[field] = "%s/%s/20%s" % /([0-9]{2})\.([0-9]{2})\.([0-9]{2})/.match(value)[1..3]
              }
            }
            normalise_vacancies = {
              "FULL" => 0,
              /no vacancies/i => 0,
              "See comments" => nil,
              "availability" => nil,
              /.*/ => -> (row, field, value) { row[field] = value.to_i }
            }
            config.normalisers = {
              "contact" => trimmer,
              "telephone" => trimmer,
              "email_address" => trimmer.merge(
                /.*/ => -> (row, field, value) {
                  row[field] = value.split(" ").reject {|v| !v.include?("@") }.join(",")
                }
              ),
              "date_vacancies_were_updated" => {
                "-" => "",
                "NR" => "",
                "N/R" => "",
                "No Reply" => ""
              }.merge(convert_dotted_dates),
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
