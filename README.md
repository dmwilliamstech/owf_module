# OWF Module #

Build and Installs OWF on a vagrant box with Puppet.

Tested on:

 * Centos 6.4

Follow these steps to use:

 * Install vagrant (http://www.vagrantup.com/)
 * Add a box to your vagrant installation "vagrant box add owf http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130731.box"
 * Clone this repo
 * Cd into owf_module
 * Modify Vagrant file to use this script (i.e. 
 * Vagrant.configure("2") do |config|
        config.vm.define "ozone" do |ozone|
        ozone.vm.box = "OWF"
        end
        config.vm.provision "puppet" do |puppet|
        puppet.manifests_path ="manifests/owf_module"
        puppet.manifest_file="base.pp"
        puppet.options = ['--verbose --debug']
        end
end
 * run "vagrant up"
 * After puppet script succesffuly runs "vagrant ssh ozone"
 * cd into owf
 * execute "grails run-app" or "grails test-app"(whichever is needed)
 


Inside vagrant box script should be in '/tmp/vagrant-puppet/manifests/owf_module'



#Author
David Williams
