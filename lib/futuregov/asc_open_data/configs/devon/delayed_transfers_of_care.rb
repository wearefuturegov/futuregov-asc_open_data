module Futuregov
  module ASCOpenData
    module Configs
      module Devon
        module DelayedTransfersOfCare
          include Common

          def self.configure!(config)
            config.preparsers[:trim_top] = -> (file) do
              line_no = 0
              until file.readline =~ /^Year,/ do
                line_no += 1
              end
              file.rewind
              line_no.times { file.gets }
            end
          end
        end
      end
    end
  end
end
