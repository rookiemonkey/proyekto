module Seeds
  class UserAcessible
    def self.produce
      ::User.create(email: 'one@gmail.com',
                    full_name: 'Name One',
                    organization: Seeds::Organization.current_tenant,
                    password: '987654321')

      ::Activity.create(description: "[SEEDER]: 'Name One' has joined the organization",
                        organization: Seeds::Organization.current_tenant,
                        activity_type: 'staff')

      ::User.create(email: 'two@gmail.com',
                    full_name: 'Name Two',
                    organization: Seeds::Organization.other_tenant,
                    password: '987654321')

      ::Activity.create(description: "[SEEDER]: 'Name Two' has joined the organization",
                        organization: Seeds::Organization.other_tenant,
                        activity_type: 'staff')
    end
  end
end