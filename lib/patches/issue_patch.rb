require_dependency 'issue'

module Patches
  module IssuePatch
    include Redmine::I18n
    include CustomImprovements

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        validate :validate_freelance, on: [:update]
      end
    end

    module InstanceMethods

      def validate_freelance

        def freelance_field_on_complete
          check = false
          fields_ids = SsrFreelanceHelper.mark_custom_field_freelance.map{ |item| item.last }
          custom_field_values.map do |item|
            if fields_ids.include?(item.custom_field.id)
              check = true if item.value.to_i > 0
            end
          end
          check
        end

        def freelance_role_check_field_no
          check = false
          field_id = Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_id'].to_i
          custom_field_values.map do |item|
            if field_id == item.custom_field.id
              check = true if item.value.to_i == 0
              check = (check and freelance_role_check_change_field)
              item.value = '1' if check
            end
          end
          check
        end


        def freelance_role_check_change_field
          id_field_freelance = Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_id'].to_i

          cf = (custom_field_values.map do |item|
            if item.custom_field.id == id_field_freelance
              item
            end
          end).compact

          if cf.first.value == '0' and cf.first.value_was == '1'
            project_role_ids = project.users.find(assigned_to).roles.ids
            freelance_rol_ids = SsrFreelanceSetting.all.map { |item| item.role_id }
            check = freelance_rol_ids.map { |item| true if project_role_ids.include?(item) }.compact.uniq.pop
          end

          return true if check

        end

        def freelance_check_off_complete_fields
          id_field_freelance = Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_id'].to_i
          id_field_freelance_check = false
          check = false
          fields_ids = SsrFreelanceHelper.mark_custom_field_freelance.map{ |item| item.last }
          cf = (custom_field_values.map do |item|

            if fields_ids.include?(item.custom_field.id)
              binding.pry
              if item.value.to_i > 0
                check = true
              end
            end
            if item.custom_field.id == id_field_freelance
              id_field_freelance_check = true if item.value == '0'
            end
          end).compact
          id_field_freelance_check and check
        end





        errors.add :base, :stop_change_field if freelance_role_check_change_field

        errors.add :base, :stop_change_complete_field         if freelance_role_check_field_no

        errors.add :base, :freelance_check_off_complete_fields if freelance_check_off_complete_fields and !(freelance_role_check_field_no and freelance_field_on_complete)

      end

    end

  end
end