require 'formula'

class Uhd < Formula
  homepage 'http://www.ettus.com/'
  url 'https://github.com/EttusResearch/uhd/archive/release_003_007_002.tar.gz'
  sha1 '76fd06744e82f4d4f8734c100fa9bca309a0a2ae'
  version '3.7.2'
  head 'git://github.com/EttusResearch/UHD-Mirror.git'

  depends_on 'cmake' => :build
  depends_on 'automake' => :build
  depends_on 'pkgconfig' => :build
  depends_on :python
  depends_on 'libusb'
  depends_on 'boost'
  depends_on 'orc'
  depends_on 'doxygen' if ARGV.include?('--with-docs')
  
  def options
    [
      ['--with-docs', 'Install UHD documentation'],
    ]
  end
  
  resource 'docutils' do
    url 'https://pypi.python.org/packages/source/d/docutils/docutils-0.12.tar.gz'
    sha1 '002450621b33c5690060345b0aac25bc2426d675'
  end
  
  resource 'Cheetah' do
    url 'https://pypi.python.org/packages/source/C/Cheetah/Cheetah-2.4.4.tar.gz'
    sha1 'c218f5d8bc97b39497680f6be9b7bd093f696e89'
  end

  def install

    ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
    ENV.prepend_create_path 'PATH', libexec+'bin'
    
    setup_args = [ "setup.py", "install", "--prefix=#{libexec}" ]
    resource('Cheetah').stage { system "python", *setup_args }
    resource('docutils').stage { system "python", *setup_args } if ARGV.include?('--with-docs')
    
    
    cd "host"
    mkdir "build"
    cd "build"
    system "cmake","../","-DCMAKE_INSTALL_PREFIX=#{prefix}", "-DPYTHON_LIBRARIES=#{libexec}/lib/python2.7/site-packages", *std_cmake_args
    system "make install"
  end

end
