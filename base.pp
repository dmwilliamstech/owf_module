

package {'git':
	ensure=>'present',
	provider=>'yum'
} ->
package {'java-1.6.0-openjdk':
	ensure=> 'present',
	provider=>'yum'
} ->
exec {'set_java_home':
	require=>Package['java-1.6.0-openjdk'],
	command=>"/bin/echo 'export JAVA_HOME=/usr/lib/jvm/java-1.6.0-openjdk-1.6.0.0.x86_64/jre' >> /home/vagrant/.bashrc"
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
exec {'grails_bashrc':
	command=>"/bin/echo 'export GRAILS_HOME=/home/vagrant/grails-1.3.7/bin' >> /home/vagrant/.bashrc"
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
exec {'create_groovy_home':
	command=>"/bin/echo 'export GROOVY_HOME=/opt/groovy-1.8.9' >> /home/vagrant/.bashrc"
} ->
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
        logoutput=>true
} ->
exec {'set_global_path':
	path=>'/bin/echo',
	command=>"echo 'export PATH=$JAVA_HOME/bin:$GRAILS_HOME/bin:$PATH:$GROOVY_HOME/bin:$PATH",
	refreshonly=>true

}
exec {'source_bashrc':
	provider=>'shell',
        cwd=>'/home/vagrant',
        refreshonly=>true,
        command=>'source .bashrc'
}->
exec {'run_owf':
	cwd=>'/home/vagrant/owf',
	command=>"/home/vagrant/grails-1.3.7/bin/grails run-app",
}->
exec {'owfRunning?':
	command=> '/usr/bin/wget -q0- https://localhost:8443/owf'
}

