require_relative "../../ssr_freelance.rb"
require_relative '../../../app/helpers/ssr_freelance_helper.rb'
module SsrFreelance
  module Hooks
    module Status
      class SsrFreelanceHookListener < Redmine::Hook::ViewListener

        render_on(:view_issues_new_top, partial: 'freelance/role_fl')

        render_on(:view_issues_bulk_edit_details_bottom, partial: 'freelance/role_fl')
        render_on(:view_issues_edit_notes_bottom, partial: 'freelance/role_fl')

        render_on(:view_issues_show_details_bottom, partial: 'freelance/role_fl')
        render_on(:view_issues_form_details_bottom, partial: 'freelance/role_fl')


        # controller issue hook create and update
        include SsrFreelanceHelper

        def controller_issues_save_dry(data = {})

          project = data[:issue].project
          if project and data[:issue].assigned_to
            user_id = data[:issue].assigned_to.id
            if user_id
              begin
                role_user_ids = Member.where(user_id: user_id).find_by(project_id: project.id).role_ids
              rescue
                role_user_ids = []
              end
            end
          else
            role_user_ids = data[:issue].assigned_to.roles.ids if data[:issue].assigned_to
          end
          check = SsrFreelanceSetting.all.map { |item| true if role_user_ids.include?(item.role_id) }.compact.pop if data[:issue].assigned_to
          #
          #
          check_pay_info = Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_accrued'].to_i
          data[:issue].custom_field_values.each do |item|
            if check_pay_info == item.custom_field.id
              if item.value.to_f > 0
                if data[:issue].status_id == 1
                  data[:issue].status_id = 2
                end
              end
            end
            if check and item.custom_field.id == Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_id'].to_i
              if item.value == '0'
                item.value = '1'
              end
            end
          end

          # Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_accrued']
          # Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_paid']
          # Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_status']
          # Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_pay_user_field_id']


        end
        def controller_issues_before_save_dry(data)

          controller_issues_save_dry(data)
        end

        def controller_issues_new_before_save(data = {})
          controller_issues_save_dry(data)
        end

        #
        def controller_issues_edit_before_save(data = {})
          controller_issues_save_dry(data)
        end

        #
        #

        def controller_issues_bulk_edit_before_save(data={})
          check = false
          role_ids = data[:project].users.find(data[:issue].assigned_to_id).roles.ids
          role_ids.each do |item|
            binding.pry
            if SsrFreelanceSetting.where(role_id: item) != []
              check = true
            end
          end
          if check
            data[:issue].custom_field_values.each do |item|
              if item.custom_field.id == Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_id'].to_i
                item.value = 1
              end
            end
          end
        end

      end
    end
  end
end