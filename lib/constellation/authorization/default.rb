module Constellation
  module Authorization
    module Default
      module UserExtensions
        def self.included(recipient)
          recipient.extend ClassMethods 
        end

        module ClassMethods
          def acts_as_authorized_user
            include Constellation::Authorization::Default::UserExtensions::InstanceMethods
          end
        end

        module InstanceMethods
          def has_role?(role)
            self.send(:"#{role}?") if self.respond_to?(:"#{role}?")
          end
        end
      end

      module ModelExtensions
        def self.included(recipient)
          recipient.extend ClassMethods
        end

        module ClassMethods
          def acts_as_authorizable
            include Constellation::Authorization::Default::ModelExtensions::InstanceMethods
          end
        end

        module InstanceMethods
          def accepts_role?(role, user)
            if self.respond_to? role
              self.send(role) == user 
            elsif self.respond_to? role.pluralize
              self.send(role.pluralize).include?(user)
            else
              false
            end
          end
        end
      end
    end
  end
end