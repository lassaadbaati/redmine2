class Daccess < ActiveRecord::Base
  def self.appkey
    "6d0g4hbksht2jet"
  end

  def self.appsecret
    "fnpv3suf466grxm"
  end

  def self.accesstype
    :dropbox
  end
end
