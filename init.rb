Redmine::Plugin.register :sunstrike_redmine_freelance_plg do
  name 'Sunstrike Redmine Freelance plugin'
  author 'Pecherskyi Alexei'
  description 'Facilitate work with freelancers in redmine'
  version '0.0.1'
  url 'http://sunstrikestudios.com'
  author_url 'http://example.com/about'

  ON_OFF_CONST = [['Включен', 0], ['Выключен', 1]]
  settings default: {'sunstrike_freelance_auto_select' => '0',
                     'sunstrike_freelance_field_id' => '0',
                     'sunstrike_freelance_role_id' => '0',
                     'sunstrike_freelance_field_page' => '0',
                     'sunstrike_freelance_pay_field_id' => '0'}, partial: 'freelance/settings/freelance'


  require_dependency 'ssr_freelance'
  # path = './lib/patches'
  # object_to_prepare = Rails.configuration
  # object_to_prepare.to_prepare do
  #
  #   require_relative "#{path}/issues_controller_patch.rb"
  #
  #   require_relative "#{path}/issue_patch.rb"
  #
  #   require_relative "#{path}/settings_controller_patch.rb"
  #
  #   require_relative "#{path}/custom_field_patch.rb"
  #
  # end
end
ActionDispatch::Callbacks.to_prepare do
  IssuesController.send(:include, SsrFreelance::Patches::IssuesControllerPatch)
  Issue.send(:include, SsrFreelance::Patches::IssuePatch)
  SettingsController.send :include, SsrFreelance::Patches::SettingsControllerPatch
end