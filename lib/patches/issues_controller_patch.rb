require_dependency 'issues_controller'

module Patches
  module IssuesControllerPatch
    def self.included(base)
      base.class_eval do
        helper :ssr_freelance
      end
    end
  end
end