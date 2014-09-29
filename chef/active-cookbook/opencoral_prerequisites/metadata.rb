name             'opencoral_prerequisites'
maintainer       'University of Utah Nanofab'
maintainer_email 'nanofab-support@eng.utah.edu'
license          'All rights reserved'
description      'Installs/Configures OpenCoral'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "ant"
depends "apt"
depends "apache2"
depends "git"
depends "java"
depends "runit"
