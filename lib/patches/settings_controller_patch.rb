require_dependency 'settings_controller'

module Patches
  module SettingsControllerPatch
    def self.included(base)
      base.class_eval do
        helper :ssr_freelance
      end
    end
  end
end
