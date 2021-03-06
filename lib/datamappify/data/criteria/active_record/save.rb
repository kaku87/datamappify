require 'datamappify/data/criteria/relational/save'

module Datamappify
  module Data
    module Criteria
      module ActiveRecord
        class Save < Relational::Save
          private

          def save_record
            record = source_class.where(criteria).first_or_initialize
            save(record)
          end

          def save(record)
            record.update_attributes attributes_and_values
            record
          end
        end
      end
    end
  end
end
