
package {'git':
	ensure=>'present',
	provider=>'yum'
} ->
package {'java-1.6.0-openjdk-devel':
	ensure=> 'present',
	provider=>'yum'
} ->
exec {'set_java_home':
	require=>Package['java-1.6.0-openjdk-devel'],
	command=>"/bin/echo 'export JAVA_HOME=/usr/lib/jvm/java-1.6.0-openjdk-1.6.0.0.x86_64' >> /home/vagrant/.bashrc"
} ->
exec{'move_tool-jar':
	path=>['/usr/bin', '/usr/sbin/', '/bin'],
	command=>'sudo cp /usr/lib/jvm/java-1.6.0-openjdk.x86_64/lib/tools.jar /usr/lib/jvm/java-1.6.0-openjdk.x86_64/jre/lib/ext/'
} ->
package{'ruby':
	ensure=>'present',
	provider=>'yum'
}->
package{'unzip':
	ensure=>'present',
	provider=>'yum'
}->
package {'curl':
	ensure=>'present',
	provider=>'yum'
}
exec {'install_gvm':
	cwd=>'/home/vagrant',
	command=>"curl -s get.gvmtool.net | bash",
	path=>['/usr/bin', '/usr/sbin', '/bin'],
	require=> Package['curl']
}->

exec {'source_gvm_init':
        provider=>'shell',
        cwd=>'/home/vagrant/.gvm/bin',
        refreshonly=>true,
        command => 'source gvm-init.sh',
}->
package {'rubygems':
	ensure=>'present',
	provider=>'yum'
}->
package {'sass':
	provider=>'gem',
	ensure=>'3.1.3',
	require=>Package['rubygems']
}->
package{'compass':
	provider=>'gem',
	ensure=>'0.11.3',
	require=>Package['rubygems']
}->
exec {'install_grails_1.3.7':
	path=>'/usr/bin/',
	cwd=>'/home/vagrant/',        
	command=>'wget http://dist.springframework.org.s3.amazonaws.com/release/GRAILS/grails-1.3.7.zip',
        creates=>'/home/vagrant/grails-1.3.7.zip',
	logoutput=>true
}->
exec {'unzip_grails':
        cwd=>'/home/vagrant',
        command=> '/usr/bin/unzip grails-1.3.7.zip',
        creates => '/home/vagrant/grails-1.3.7'
}->
exec {'chmod_grails':
	path=>'/bin/',
	cwd=>'/home/vagrant/grails-1.3.7/bin',
	command=>'chmod u+x grails'
}->
exec {'dl_groovy_1.8':
        cwd=> '/opt',
        command=> '/usr/bin/wget http://dist.groovy.codehaus.org/distributions/groovy-binary-1.8.9.zip',
        creates=> '/opt/groovy-binary-1.8.9.zip',
}->
exec {'unzip_groovy':
        cwd=>'/opt',
        command=> '/usr/bin/unzip groovy-binary-1.8.9.zip',
        creates => '/opt/groovy-1.8.9'
}->
exec {'dl_ant':
	cwd=> '/opt',
	command=> '/usr/bin/wget http://archive.apache.org/dist/ant/binaries/apache-ant-1.8.3-bin.zip',
	creates=> '/opt/apache-ant-1.8.3-bin.zip'
}->
exec {'untar_ant':
	cwd=>'/opt',
	command=> '/usr/bin/unzip -zxvf apache-ant-1.8.3-bin.zip',
	creates => '/opt/apache-ant-1.8.3',
	logoutput=>true
}->
package {'ant-contrib':
	ensure=>'present',
	provider=>'yum'
} ->
exec {'clone_owf':
	cwd =>'/home/vagrant',
        path => '/usr/bin',
        command=>'git clone git://github.com/dmwilliamstech/owf.git',
	timeout=>0,
	require=>Package['git'],
        logoutput=>true,
	creates=>'/home/vagrant/owf'
} ->
exec{'change_owf_owner':
	cwd=>'/home/vagrant',
	path=>['/usr/bin', '/usr/sbin/', '/bin'],
	command=>'chown -R vagrant owf'
}->
exec{'cp_ivy_jar':
	cwd=>'/home/vagrant/owf/build-libs',
        path=>['/usr/bin', '/usr/sbin/', '/bin'],
        command=>'cp ivy-2.1.0.jar /usr/share/ant/lib'
}->
exec{'/tmp/vagrant-puppet/manifests/owf_module/exportPath.sh':
	path=>['/bin/sh', '/bin/bash'],
	command=>'/tmp/vagrant-puppet/manifests/exportPath.sh',
} ->
exec {'restart_shell':
	path=>['/bin/sh', '/bin/bash', '/usr/bin', '/bin', '/usr/sbin'],
	command=>'bash'
}->
exec {'test_owf':
	cwd=>'/home/vagrant/owf',
	path=>['/usr/bin', '/bin', '/home/vagrant/grails-1.3.7/bin'],
	command=>"grails test-app"
}->
exec {'run_owf':
	path=>['/usr/bin', '/bin', '/home/vagrant/grails-1.3.7/bin'],
	cwd=>'/home/vagrant/owf',
	command=>"grails run-app",
}->
exec {'owfRunning?':
	command=> '/usr/bin/wget -q0- https://localhost:8443/owf'
}

