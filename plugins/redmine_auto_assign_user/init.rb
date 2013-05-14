require 'redmine'

require_dependency 'auto_assign_user/hooks'

Redmine::Plugin.register :redmine_auto_assign_user do
  name 'Redmine Auto Assign User plugin'
  author 'Michael Bischof'
  description 'If an user forget to assign the issue, this plugin will auto-assign to the defined project manager roles.'
  version '1.0.0'
  url ''
  author_url ''
  requires_redmine :version_or_higher => '1.1.0'

  settings :default => {
    'manager_roles' => [],
    'client_roles' => []
  }, :partial => 'settings/auto_assign_user_settings'
end
