module Seeds
  class Organization
    @@count = 2
    @@all = nil
    @@current_tenant = nil
    @@other_tenant = nil

    def self.produce
      @@count.times { ::Organization.create(name: Faker::Company.name, plan: 'enterprise') }
      @@all = ::Organization.all
      @@current_tenant = @@all.first
      @@other_tenant = @@all.last
    end

    def self.count
      @@count
    end

    def self.all
      @@all
    end

    def self.current_tenant
      @@current_tenant
    end

    def self.other_tenant
      @@other_tenant
    end
  end
end