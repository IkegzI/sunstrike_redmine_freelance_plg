require_dependency 'issue'
module SsrFreelance
  module Patches
    module IssuePatch
      include Redmine::I18n
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          validate :ssr_validate
        end
      end

      module InstanceMethods

        def ssr_validate

          # def freelance_field_on_complete
          #   check = false
          #   fields_ids = SsrFreelanceHelper.mark_custom_field_freelance.map { |item| item.last }
          #   custom_field_values.map do |item|
          #     if fields_ids.include?(item.custom_field.id)
          #       check = true if item.value.to_i > 0
          #     end
          #   end
          #   check
          # end

          # def freelance_role_check_field_no
          #   check = false
          #   field_id = Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_id'].to_i
          #   if assigned_to.nil?
          #     custom_field_values.map do |item|
          #       if field_id == item.custom_field.id
          #         check = true if item.value.to_i == 0 and item.value_was.to_i == 1
          #       end
          #     end
          #   end
          #   check
          # end

# поле ассоциирующее изменилось + роль фрилансера


#поле ассоциирующее не изменилось


          def freelance_role_check_turn_off # yes
            check = false
            id_field_freelance = Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_id'].to_i
            cf = (custom_field_values.map do |item|
              if item.custom_field.id == id_field_freelance
                item
              end
            end).compact
            if cf.first.value == '0' and assigned_to
              check = true
            end
            check
          end
          #
          # def freelance_role_check_turn_on
          #   check = false
          #   id_field_freelance = Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_id'].to_i
          #   cf = (custom_field_values.map do |item|
          #     if item.custom_field.id == id_field_freelance
          #       item
          #     end
          #   end).compact
          #   if cf.first.value == '1' and assigned_to
          #     check = true
          #   end
          #   check
          # end


          # def freelance_role_check_change_turn_on
          #   check = false
          #   id_field_freelance = Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_id'].to_i
          #   cf = (custom_field_values.map do |item|
          #     if item.custom_field.id == id_field_freelance
          #       item
          #     end
          #   end).compact
          #   if cf.first.value == '1' and (cf.first.value_was == '0' or cf.first.value_was == '') and assigned_to
          #     check = true
          #   end
          #   check
          # end

          def freelance_role_check_change_turn_off # yes
            check = false
            id_field_freelance = Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_id'].to_i
            cf = (custom_field_values.map do |item|
              if item.custom_field.id == id_field_freelance
                item
              end
            end).compact
            if cf.first.value == '0' and cf.first.value_was == '1' and assigned_to
              check = true
            end
            check
          end

          def freelance_check_complete_fields # yes
            check = false
            fields_ids = SsrFreelanceHelper.mark_custom_field_freelance.map { |item| item.last }
            custom_field_values.map do |item|
              if fields_ids.include?(item.custom_field.id)
                if item.value.to_i > 0 or item.value.scan(/[а-яА-Яa-zA-Z]+/).size > 0
                  check = true
                end
              end
            end
            check
          end


          def freelance_role_check # yes
            id_field_freelance = Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_id'].to_i
            check = false
            cf = (custom_field_values.map do |item|
              if item.custom_field.id == id_field_freelance
                item
              end
            end).compact
            if cf.first.value == '0' and assigned_to
              project_role_ids = Member.where(user_id: assigned_to.id).find_by(project_id: project.id).role_ids
              freelance_rol_ids = SsrFreelanceSetting.all.map { |item| item.role_id }
              check = freelance_rol_ids.map { |item| true if project_role_ids.include?(item) }.compact.uniq.pop
              if check
                check
              end
              # end
              check
              #

            end
          end


          def assigned_to_nil # yes
            check = false
            check = true if assigned_to.nil?
            check
          end

#freelance

#Задачу больше делает не фрилансер? Чтобы изменить поле “Делает фрилансер” на “Нет” удалите информацию из полей “Фриланс (начислено)”, “Фриланс (выплачено)” и “Фриланс статус”
# роль - фрилансер, изменяем ассоциирующее поле stop_change_complete_field
          errors.add :base, :stop_change_complete_field if freelance_check_complete_fields and freelance_role_check_change_turn_off and !(freelance_role_check) #freelance_check_off_complete_fields

          errors.add :base, :freelance_check_off_complete_fields if freelance_check_complete_fields and freelance_role_check_turn_off and !(freelance_role_check_change_turn_off)


#stop_change_field: "Тикет назначен на пользователя, работающего на фрилансе. Нельзя в поле 'Делает фрилансер' установить значение 'Нет'"
#пользователь - фрилансер               #не изменилось, значение нет
# errors.add :base, :stop_change_field if freelance_role_check


# Назначено - пустое значение
          errors.add :base, :assigned_to_nil if assigned_to_nil and freelance_check_complete_fields

          #
        end
      end
    end
  end
end
# end
