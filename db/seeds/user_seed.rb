module Seeds
  class User
    @@count = 5
    @@all = nil
    @@current_user = nil

    def self.produce
      Seeds::Organization.all.each do |organization|
        @@count.times do
          ::User.create(email:  Faker::Internet.unique.safe_email,
                        full_name: Faker::Name.name,
                        organization: organization,
                        password: '987654321')
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