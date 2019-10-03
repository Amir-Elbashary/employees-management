module FactoriesInitializers
  def initialize_app_settings(ip_addresses: [], work_from_home: 2)
    @settings = create(:setting, ip_addresses: ip_addresses, work_from_home: work_from_home)
  end
end
