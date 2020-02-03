require_relative "../sunstrike_redmine_freelance_plg.rb"

module Hooks
  include SunstrikeRedmineFreelancePlg
  module Status
    class SunstrikeRedmineFreelancePlgHookListener < Redmine::Hook::ViewListener

      # render_on(:view_issues_show_details_bottom, partial: 'improvements/status')


    end
  end
end