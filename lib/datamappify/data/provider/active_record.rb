module Datamappify
  module Data
    module Provider
      module ActiveRecord
        extend CommonProvider

        # @return [ActiveRecord::Base]
        def self.build_record_class(source_class_name)
          Datamappify::Data::Record::ActiveRecord.const_set(
            source_class_name, Class.new(::ActiveRecord::Base)
          )
        end
      end
    end
  end
end
