require 'formula'

class Gnuradio < Formula
  homepage 'http://gnuradio.org'
  
  url 'http://gnuradio.org/releases/gnuradio/gnuradio-3.7.5.tar.gz'
  sha256 '467f62190687a34f9faa18be8d650e28d7046b94070b1b6d94355c28beb76243'
  head 'http://gnuradio.org/git/gnuradio.git'
  version "3.7.5"

  depends_on 'cmake' => :build
  depends_on :fortran => :build
  depends_on :python
  depends_on 'boost'
  depends_on 'cppunit'
  depends_on 'gsl'
  depends_on 'fftw'
  depends_on 'swig'
  depends_on 'pygtk'
  depends_on 'orc'
  depends_on 'log4cpp'
  
  depends_on 'uhd' if ARGV.include?('--with-uhd')
  depends_on 'qt' if ARGV.include?('--with-qt')
  depends_on 'pyqt' if ARGV.include?('--with-qt')
  depends_on 'pyqwt' if ARGV.include?('--with-qt')
  
  depends_on 'sdl' if ARGV.include?('--with-video-sdl')

  depends_on 'wxmac' if ARGV.include?('--with-wx')
  depends_on 'wxpython' if ARGV.include?('--with-wx')
  
  depends_on 'portaudio' if ARGV.include?('--with-portaudio')
  depends_on 'jack' if ARGV.include?('--with-jack')
  
  depends_on 'doxygen' if ARGV.include?('--with-docs')
  depends_on 'graphviz' if ARGV.include?('--with-docs')
  depends_on 'sphinx' if ARGV.include?('--with-docs')
  depends_on :tex if ARGV.include?('--with-docs')
  
  depends_on 'cppzmq' if ARGV.include?('--with-zeromq')

  def options
    [
      ['--enable-performance-counters', 'Enable support for performance counters (EXPERIMENTAL)'],
      ['--with-qt', 'Install GNU Radio with support for Qt GUI'],
      ['--with-wx', 'Install GNU Radio with support for Wx GUI'],
      ['--with-zeromq', 'Install GNU Radio with support for the ZeroMQ lightweight messaging kernel (EXPERIMENTAL)'],
      ['--with-ctrlport', 'Enable control port enhancements (EXPERIMENTAL)'],
      ['--with-uhd', 'Install GNU Radio with support for UHD'],
      ['--with-video-sdl', 'Install GNU Radio with support for SDL-based video'],
      ['--with-docs', 'Install GNU Radio documentation'],
      ['--with-jack', 'Install GNU Radio with support for JACK audio'],
      ['--with-portaudio', 'Install GNU Radio with support for portaudio audio'],
    ]
  end
  
  resource 'Cheetah' do
    url 'https://pypi.python.org/packages/source/C/Cheetah/Cheetah-2.4.4.tar.gz'
    sha1 'c218f5d8bc97b39497680f6be9b7bd093f696e89'
  end
  
  resource 'lxml' do
    url 'https://pypi.python.org/packages/source/l/lxml/lxml-3.3.6.tar.gz'
    sha1 '9ed51835a5c97d34500055591209928980195b66'
  end
  
  resource 'numpy' do
    url 'https://pypi.python.org/packages/source/n/numpy/numpy-1.8.2.tar.gz'
    sha1 '4dd41f2be2ac1bdacfb0c4ee71a7f071458a8b29'
  end
  
  resource 'scipy' do
    url 'https://pypi.python.org/packages/source/s/scipy/scipy-0.14.0.tar.gz'
    sha1 'faf16ddf307eb45ead62a92ffadc5288a710feb8'
  end
  
  resource 'matplotlib' do
    url 'https://pypi.python.org/packages/source/m/matplotlib/matplotlib-1.4.0.tar.gz'
    sha1 'aff55bd46748df6c7a5e126905e7ddf5cdbfc3fa'
  end
  
  resource 'PyOpenGL' do
    url 'https://pypi.python.org/packages/source/P/PyOpenGL/PyOpenGL-3.1.0.tar.gz'
    sha1 'f53d537e5c1b79f7593a18c51ed616738f8a5d5a'
  end
  
  resource 'PyOpenGLAccelerate' do
    url 'https://pypi.python.org/packages/source/P/PyOpenGL-accelerate/PyOpenGL-accelerate-3.1.0.tar.gz'
    sha1 'a2b6e4aa39b2de1ccbdbd5b51af8df9a90777e3b'
  end
  
  patch :p0 do
    url "https://trac.macports.org/export/125003/trunk/dports/science/gnuradio/files/patch-remove-SIZE_T_32.diff"
    sha1 "a3402b714081105d4258292ec72f3a895acdc509"
  end
  
  patch :p0 do
    url "https://trac.macports.org/export/125003/trunk/dports/science/gnuradio/files/patch-cmake-expand.release.diff"
    sha1 "fc77e6905f635307850fd579cf913e1c78871196"
  end

  def install

    mkdir 'build' do
      
      ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
      ENV.prepend_create_path 'PATH', libexec+'bin'

      setup_args = [ "setup.py", "install", "--prefix=#{libexec}" ]
      resource('numpy').stage { system "python", *setup_args }
      resource('scipy').stage { system "python", *setup_args }
      resource('matplotlib').stage { system "python", *setup_args }
      resource('lxml').stage { system "python", *setup_args }
      resource('Cheetah').stage { system "python", *setup_args }
      resource('PyOpenGL').stage { system "python", *setup_args }
      resource('PyOpenGLAccelerate').stage { system "python", *setup_args }
      
      
      args = std_cmake_args
      args << "-DCMAKE_PREFIX_PATH=#{prefix}"
      args << "-DCMAKE_MODULES_DIR=#{prefix}/share/cmake"
      args << "-DPYTHON_LIBRARIES=#{libexec}/lib/python2.7/site-packages"
      args << "-DENABLE_PERFORMANCE_COUNTERS=OFF" unless ARGV.include?('--enable-performance-counters')
      args << '-DENABLE_GR_QTGUI=OFF' unless ARGV.include?('--with-qt')
      args << '-DENABLE_GR_WXGUI=OFF' unless ARGV.include?('--with-wx')
      args << '-DENABLE_DOXYGEN=OFF' unless ARGV.include?('--with-docs')
      args << '-DENABLE_GR_CTRLPORT=OFF' unless ARGV.include?('--with-ctrlport')
      args << '-DENABLE_GR_UHD=OFF' unless ARGV.include?('--with-uhd')
      args << '-DENABLE_GR_ZEROMQ=OFF' unless ARGV.include?('--with-zeromq')
      args << '-DENABLE_GR_VIDEO_SDL=OFF' unless ARGV.include?('--with-video-sdl')


      system 'cmake', '..', *args
      system 'make install'
      inreplace "#{prefix}/etc/gnuradio/conf.d/grc.conf", prefix, HOMEBREW_PREFIX
    end
  end
end
