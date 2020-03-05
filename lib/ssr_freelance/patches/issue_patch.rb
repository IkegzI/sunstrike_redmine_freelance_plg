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
              ch = freelance_rol_ids.map { |item| true if project_role_ids.include?(item) }.compact.uniq.pop
              if ch
                check = true
              end
            end
            check
          end

          # параметр “Фриланс (начислено)” пустой, равен нулю или меньше нуля, система должна выдать ошибку при попытке сохранить любое из значений в поле “Фриланс статус” кроме пустого
          def freelance_check_cash_field
            #sunstrike_freelance_field_paid
            check = false
            id_status = Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_status'].to_i
            id_cash = Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_accrued'].to_i
            cash = 0
            status_u = 0
            custom_field_values.each do |item|
              if item.custom_field.id == id_status
                status_u = item.value
              end
              if item.custom_field.id == id_cash
                cash = item.value.to_i
              end
            end
            if status_u != ''
              if cash <= 0
                check = true
              end
            end
            check
          end

          # параметр “Фриланс (выплачено)” пустой, равен нулю или меньше нуля,
          def freelance_check_cash_pay
            check = false
            check_select = false
            value_id = Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_status'].to_i
            value_50 = Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_status_50']
            value_100 = Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_status_100']
            value_pay_id = Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_paid'].to_i
            custom_field_values.each do |item|
              if item.custom_field.id == value_id
                if item.value == value_50 or item.value == value_100
                  check_select = true
                end
              end
            end
            if check_select
              custom_field_values.each do |item|
                if item.custom_field.id == value_pay_id
                  if item.value.to_i <= 0
                    check = true
                  end
                end
              end
            end
            check
          end

          # нельзя заполнить “Фриланс (выплачено)” если параметр “Фриланс (начислено)” пустой
          def freelance_check_cash_payment
            check_paid = false
            check_accrued = false
            check = false
            value_paid = 0
            value_accrued = 0
            value_paid_id = Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_paid'].to_i
            value_accrued_id = Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_accrued'].to_i
            cf = custom_field_values
            cf.each do |item|
              if item.custom_field.id == value_accrued_id
                value_accrued = item.value.to_f
                if item.value.to_i <= 0
                  check_accrued = true
                end
              end
              if item.custom_field.id == value_paid_id
                value_paid = item.value.to_f
                if item.value.to_i > 0
                  check_paid = true
                end
              end
            end
            if (check_accrued and check_paid) or value_paid > value_accrued
              check = true
            end
            check
          end

          def assigned_to_nil # yes
            check = false
            check = true if assigned_to.nil?
            check
          end

          def freelance_status_on
            #sunstrike_freelance_field_id
            check = false
            field_id = Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_id'].to_i
            custom_field_values.each do |item|
              if item.custom_field.id == field_id
                if item.value == '1'
                  check = true
                end
              end
            end
            check
          end

          def freelance_change_status_in_work
            #sunstrike_freelance_field_accrued
            id_cash = Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_accrued'].to_i
            custom_field_values.each do |item|
              if item.custom_field.id == id_cash
                if item.value.to_f > 0
                  issue.status = 2 if status_id == 1
                  a = ''
                end
              end
            end
          end

          #
          def freelance_change_status_in_work
            #sunstrike_freelance_field_accrued
            id_freelance = Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_id'].to_i
            custom_field_values.each do |item|
              if item.custom_field.id == id_freelance
                if item.value.to_f > 0
                  status_id = 2 if status_id == 1
                  a = ''
                end
              end
            end
          end


          #freelance
          #Задачу больше делает не фрилансер? Чтобы изменить поле “Делает фрилансер” на “Нет” удалите информацию из полей “Фриланс (начислено)”, “Фриланс (выплачено)” и “Фриланс статус”
          # роль - фрилансер, изменяем ассоциирующее поле stop_change_complete_field
          errors.add :base, :stop_change_complete_field if freelance_check_complete_fields and freelance_role_check_change_turn_off and !(freelance_role_check) #freelance_check_off_complete_fields

          errors.add :base, :freelance_check_off_complete_fields if freelance_check_complete_fields and freelance_role_check_turn_off and !(freelance_role_check_change_turn_off)

          #stop_change_field: "Тикет назначен на пользователя, работающего на фрилансе. Нельзя в поле 'Делает фрилансер' установить значение 'Нет'"
          #пользователь - фрилансер               #не изменилось, значение нет
          errors.add :base, :stop_change_field if freelance_role_check

          # Назначено - пустое значение
          errors.add :base, :assigned_to_nil if assigned_to_nil and freelance_check_complete_fields

          # параметр “Фриланс (начислено)” пустой, равен нулю или меньше нуля, система должна выдать ошибку при попытке сохранить любое из значений в поле “Фриланс статус” кроме пустого
          #settings_sunstrike_freelance_field_status
          errors.add :base, :status_to_check_paid if freelance_check_cash_field and !freelance_check_cash_payment and freelance_status_on

          # параметр “Фриланс (выплачено)” пустой, равен нулю или меньше нуля, система должна выдать ошибку при попытке сохранить любое из значений в поле “Фриланс статус” кроме пустого
          #settings_sunstrike_freelance_field_status
          errors.add :base, :status_to_check_pay if freelance_check_cash_pay and freelance_status_on

          # нельзя заполнить “Фриланс (выплачено)” если параметр “Фриланс (начислено)” пустой
          #settings_sunstrike_freelance_field_status
          errors.add :base, :status_to_check_payment if freelance_check_cash_payment and freelance_status_on
          freelance_change_status_in_work if errors.keys.size == 0
        end
      end
    end
  end
end
# end
