require 'spec_helper'

platforms = {
  'ubuntu' => ['12.04', '14.04'],
  'debian' => ['7.0', '7.4'],
  'fedora' => %w(18 20),
  'redhat' => ['5.9', '6.5'],
  'centos' => ['5.9', '6.5'],
  'freebsd' => ['9.2'],
  'suse' => ['11.3']
}
#  'arch' =>

describe 'apache2::mod_xsendfile' do
  platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::Runner.new(:platform => platform, :version => version).converge(described_recipe)
        end

        if %w{redhat centos fedora arch}.include?(platform)
          it 'installs package mod_xsendfile' do
            expect(chef_run).to install_package('mod_xsendfile')
            expect(chef_run).to_not install_package('not_mod_xsendfile')
          end
          let(:package) { chef_run.package('mod_xsendfile') }
          it 'triggers a notification by mod_xsendfile package install to execute[generate-module-list]' do
            expect(package).to notify('execute[generate-module-list]').to(:run)
            expect(package).to_not notify('execute[generate-module-list]').to(:nothing)
          end
        end
        if %w{suse}.include?(platform)
          it 'installs package apache2-mod_xsendfile' do
            expect(chef_run).to install_package('apache2-mod_xsendfile')
            expect(chef_run).to_not install_package('not_apache2-mod_xsendfile')
          end
          let(:package) { chef_run.package('apache2-mod_xsendfile') }
          it 'triggers a notification by mod_xsendfile package install to execute[generate-module-list]' do
            expect(package).to notify('execute[generate-module-list]').to(:run)
            expect(package).to_not notify('execute[generate-module-list]').to(:nothing)
          end
        end
        if %w{debian ubuntu}.include?(platform)
          it 'installs package libapache2-mod-xsendfile' do
            expect(chef_run).to install_package('libapache2-mod-xsendfile')
            expect(chef_run).to_not install_package('not_libapache2-mod-xsendfile')
          end
        end

        apache_dir = '/etc/apache2'

        if %w(debian ubuntu).include?(platform)
          apache_dir = '/etc/apache2'
        elsif %w(redhat centos scientific fedora suse amazon oracle).include?(platform)
          apache_dir = '/etc/httpd'
        elsif platform == 'freebsd'
          apache_dir = '/usr/local/etc/apache22'
        else
          apache_dir = '/tmp/bogus'
          apache_lib_dir = '/usr/lib/apache2'
        end

        it "deletes #{apache_dir}/conf.d/xsendfile.conf" do
          expect(chef_run).to delete_file("#{apache_dir}/conf.d/xsendfile.conf").with(:backup => false)
          expect(chef_run).to_not delete_file("#{apache_dir}/conf.d/xsendfile.conf").with(:backup => true)
        end
      end
    end
  end

  it_should_behave_like 'an apache2 module', 'xsendfile', false, platforms
end
