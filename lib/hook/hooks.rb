require_relative "../ssr_freelance.rb"
require_relative '../../app/helpers/ssr_freelance_helper.rb'
module Hooks
  module Status
    class SsrFreelanceHookListener < Redmine::Hook::ViewListener
      #vieshooks
      # render_on(:view_issues_show_details_bottom, partial: 'improvements/status')
      # render_on(:view_layouts_base_html_head, partial: 'freelance/role_fl')
      render_on(:view_issues_bulk_edit_details_bottom, partial: 'freelance/role_fl')
      render_on(:view_issues_new_top, partial: 'freelance/role_fl')
      render_on(:view_issues_show_details_bottom, partial: 'freelance/role_fl')


      # controller issue hook create and update
      include SsrFreelanceHelper

    #   def controller_issues_save_dry(data = {})
    #     project = data[:issue].project
    #     if project and data[:issue].assigned_to
    #       user_id = data[:issue].assigned_to.id
    #       if user_id
    #         begin
    #           role_user_ids = Member.where(user_id: user_id).find_by(project_id: project.id).role_ids
    #         rescue
    #           role_user_ids = []
    #         end
    #       end
    #     else
    #       role_user_ids = data[:issue].assigned_to.roles.ids if data[:issue].assigned_to
    #     end
    #     check = SsrFreelanceSetting.all.map { |item| true if role_user_ids.include?(item.role_id) }.compact.pop if data[:issue].assigned_to
    #
    #
    #     data[:issue].custom_field_values.each do |item|
    #       if check and item.custom_field.id == Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_id'].to_i
    #         if item.value == '0'
    #           item.value = '1'
    #           data[:request].flash.alert = 'Значение поля "Делает фрилансер" автоматически измененно на "Да"'
    #         end
    #       end
    #     end
    #   end
    #
    #   def controller_issues_new_after_save(data = {})
    #     controller_issues_save_dry(data)
    #   end
    #
    #   def controller_issues_edit_after_save(data = {})
    #     controller_issues_save_dry(data)
    #   end
    #
    #   #before save
    #   #
    #
    #   def controller_issues_before_save_dry(data)
    #     field_id = Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_id'].to_i
    #     a = data[:issue].custom_values.map do |item|
    #
    #     end
    #   end
    #
    #   def controller_issues_new_before_save(data = {})
    #     controller_issues_save_dry(data)
    #   end
    #
    #   def controller_issues_edit_before_save(data = {})
    #     controller_issues_save_dry(data)
    #   end
    #
    #
    end
  end
end
