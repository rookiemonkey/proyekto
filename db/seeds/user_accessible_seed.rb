module Seeds
  class UserAcessible
    def self.produce
      ::User.create(email: 'one@gmail.com',
                    full_name: 'Name One',
                    organization: Seeds::Organization.current_tenant,
                    password: '987654321')

      ::User.create(email: 'two@gmail.com',
                    full_name: 'Name Two',
                    organization: Seeds::Organization.other_tenant,
                    password: '987654321')
    end
  end
end