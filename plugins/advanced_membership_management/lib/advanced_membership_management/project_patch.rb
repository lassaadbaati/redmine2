require_dependency 'project'

module AdvancedMembershipManagement
  
  module ProjectPatch
    
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)

      base.send(:include, InstanceMethods)

      # Same as typing in the class 
      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development
        
        # Hay un error con esta linea. AL parecer al momento de llamar el callback, el padre es nil
        alias_method_chain :set_parent!, :members_copied
        after_create :add_automatic_memberships
      end

    end
    
    module ClassMethods
    end
    
    module InstanceMethods
      
      def set_parent_with_members_copied!(p)
        if set_parent_without_members_copied!(p) && !p.nil?
          memberships.destroy_all unless memberships.nil?
          copy_members(p)
          true
        else
          false
        end
      end
      
      def add_automatic_memberships
        AutomaticMembership.all.each do |am|
          m = Member.new(:user_id => am.user_id, :role_ids => am.role_ids)
          members << m
        end
      end
      
    end  
  end
end

# Guards against including the module multiple time (like in tests)
# and registering multiple callbacks
unless Project.included_modules.include? AdvancedMembershipManagement::ProjectPatch
  Project.send(:include, AdvancedMembershipManagement::ProjectPatch)
end