module Futuregov
  module ASCOpenData
    module Configs
      module Common
        HEADER_NORMALISERS = {
          default: -> (fields) do
            -> (field, field_info) do
              converted = field.downcase.gsub(' ', '_')
              fields.each do |key, value|
                converted = value if key === converted
              end
              converted
            end
          end
        }

        FIELD_NORMALISERS = {
          trimmer: {
            /.*/ => -> (row, field, value) { row[field] = value.strip }
          },
          join_spaces: {
            /.*/ => -> (row, field, value) { row[field] = value.split(" ").join(",") }
          },
          convert_dotted_dates: {
            /([0-9]{2})\.([0-9]{2})\.([0-9]{2})/ => -> (row, field, value) {
              row[field] = "%s/%s/20%s" % /([0-9]{2})\.([0-9]{2})\.([0-9]{2})/.match(value)[1..3]
            }
          },
          null_dashes: {
            "-" => nil
          }
        }
      end
    end
  end
end
