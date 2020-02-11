require_relative "../ssr_freelance.rb"
require_relative '../../app/helpers/ssr_freelance_helper.rb'
module Hooks
  module Status
    class SsrFreelanceHookListener < Redmine::Hook::ViewListener
      #vieshooks
      # render_on(:view_issues_show_details_bottom, partial: 'improvements/status')
      render_on(:view_layouts_base_html_head, partial: 'freelance/role_fl')


      # controller issue hook create and update
      include SsrFreelanceHelper

      def controller_issues_save_dry(data = {})
        if project = data[:issue].project and data[:issue].assigned_to
          binding.pry
          user_id = data[:issue].assigned_to.id
          role_user_ids = project.users.find(user_id).roles.ids
        else
          role_user_ids = data[:issue].assigned_to.roles.ids if data[:issue].assigned_to
        end
        check = SsrFreelanceSetting.all.map { |item| true if role_user_ids.include?(item.role_id) }.compact.pop if data[:issue].assigned_to


        data[:issue].custom_field_values.each do |item|
        if check and item.custom_field.id == Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_id'].to_i
          item.value = '1'
          data[:request].flash.alert = 'Значение поля "Делает фрилансер" автоматически измененно на "Да"'
        end
        end
      end

      def controller_issues_new_after_save(data = {})
        controller_issues_save_dry(data)
      end

      def controller_issues_edit_after_save(data = {})
        controller_issues_save_dry(data)
      end

      #before save
      #

      def controller_issues_before_save_dry(data)
        field_id = Setting.plugin_sunstrike_redmine_freelance_plg['sunstrike_freelance_field_id'].to_i
        a = data[:issue].custom_values.map do |item|

        end
      end

      def controller_issues_new_before_save(data = {})
        controller_issues_save_dry(data)
      end

      def controller_issues_edit_before_save(data = {})
        controller_issues_save_dry(data)
      end


    end
  end
end
