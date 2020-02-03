require_dependency 'ssr_freelance'
Redmine::Plugin.register :sunstrike_redmine_freelance_plg do
  name 'Sunstrike Redmine Freelance plugin'
  author 'Pecherskyi Alexei'
  description 'Facilitate work with freelancers in redmine'
  version '0.0.1'
  url 'http://sunstrikestudios.com'
  author_url 'http://example.com/about'

  ON_OFF_CONST = [['Включен', 0], ['Выключен', 1]]
  settings default: {'sunstrike_freelance_auto_select' => 0}, partial: 'freelance/settings/freelance'


  object_to_prepare = Rails.configuration
  object_to_prepare.to_prepare do
    # cp = 'correct_project'
    # path = './lib/patches'
    # require_relative "#{path}/#{cp}/issues_controller_patch.rb"
    # IssuesController.send(:include, CorrectProject::Patches::IssuesControllerPatch)
    #
  end



end
