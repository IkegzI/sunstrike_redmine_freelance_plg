require_relative "../ssr_freelance.rb"

module Hooks
  module Status
    class SsrFreelanceHookListener < Redmine::Hook::ViewListener

      # render_on(:view_issues_show_details_bottom, partial: 'improvements/status')
      render_on(:view_layouts_base_html_head, partial: 'freelance/role_fl')


    end
  end
end