require_dependency 'issues_controller'
module SsrFreelance
module Patches
  module IssuesControllerPatch
    def self.included(base)
      base.class_eval do
        helper :ssr_freelance
        helper :ssr_freelance_pay
      end
    end

  end
end
end