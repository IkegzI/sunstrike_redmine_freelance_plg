require_dependency 'custom_field'

module Patches
  module CustomFieldPatch
    include Redmine::I18n
    include CustomImprovements

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do

        before_validation :validate_custom, on: [:create, :update]
      end
    end

    module InstanceMethods

      def validate_custom
        
      end

    end

  end
end