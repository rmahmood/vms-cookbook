maintainer       "Gridcentric Inc."
maintainer_email "support@gridcentric.com"
license          "All rights reserved"
description      "Installs/Configures vms"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.1.1"

%w{ ubuntu centos }.each do |os|
  supports os
end

%w{ apt yum }.each do |dep|
  depends dep
end
