#
# Description: This method is used to Customize the Openstack Provisioning Request
#

require 'socket'

# Get provisioning object
prov = $evm.root["miq_provision"]

#$evm.root.attributes.sort.each { |k, v| $evm.log("info", "Root:<$evm.root> Attribute - #{k}: #{v}")}
#prov.attributes.sort.each { |k, v| $evm.log("info", "Root:<$evm.root> Attribute - #{k}: #{v}")}

source_ems_id=prov.get_option(:src_ems_id)
$evm.log("info", "EVM Source ID: #{source_ems_id}")

ems=$evm.vmdb("ext_management_system").find_by_id(source_ems_id)

size=prov.get_option(:flavor)

size="#{size}".downcase.gsub('_','.')

$evm.log("info", "flavors: #{ems.flavors.inspect}")

id=0
name=""

ems.flavors.each do |flavor|
  name=flavor["name"]
  $evm.log("info", "Comparing #{name} with #{size}")
  if name == "#{size}" then
    id=flavor["id"]
    break
  end
end

$evm.log("info", "Setting flavor ID: #{id} and name: #{name}")

hostname = Socket.gethostname
domainname=hostname.split('.')[1,hostname.length].join('.')
$evm.log("info", "Storing Domain Name #{domainname} for use in cloud-init")  
prov.set_option(:domainname,domainname)
