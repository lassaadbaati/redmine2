module AutoAssignUser
  class Hooks < Redmine::Hook::ViewListener

      def controller_issues_new_before_save(context)
        auto_assign_user(context)
      end

      def controller_issues_edit_before_save(context)
        auto_assign_user(context)
      end

      def auto_assign_user(context)
        @settings ||= Setting.plugin_redmine_auto_assign_user

        if context[:params][:issue]
          # if no user assigned...
          if context[:params][:issue][:assigned_to_id].blank?
            # search all users in this project...
            members_list = context[:issue].project.members.find(:all, :include => [:user, :roles])
            # and also all manager roles...
            manager_roles = Role.find(@settings['manager_roles'])
            # for every member go trough his roles...
            members_list.each do |member|
              member.roles.each do |role|
                # and compare with the manager roles for this project...
                manager_roles.each do |manager_role|
                  if manager_role.name == role.name
                    # yeah! we found a mangager so assign this todo to him and we are all set.
                    context[:issue].assigned_to_id = member.user.id
                    return
                  end
                end
              end
            end
          end
        end
      end
  end
end
