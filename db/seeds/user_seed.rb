module Seeds
  class User
    @@count = 5
    @@all = nil
    @@current_user = nil

    def self.produce
      Seeds::Organization.all.each do |organization|
        @@count.times do
          new_colleague_full_name = ::Faker::Name.name
          
          ::User.create(email: ::Faker::Internet.unique.safe_email,
                        full_name: new_colleague_full_name,
                        organization: organization,
                        password: '987654321')

          ::Activity.create(description: "[SEEDER]: #{new_colleague_full_name} has joined the organization",
                            organization: organization,
                            activity_type: 'staff')
        end
      end

      @@all = ::User.where(organization: Seeds::Organization.current_tenant)
      @@current_user = @@all.sample
    end

    def self.all
      @@all
    end

    def self.current_user
      @@current_user
    end
  end
end