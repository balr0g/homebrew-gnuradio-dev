require "formula"

class GrBaz < Formula
  homepage "http://wiki.spench.net/wiki/Gr-baz"
  head "https://github.com/balint256/gr-baz.git"

  depends_on "cmake" => :build
  depends_on "gnuradio"
  depends_on "boost"
  # depends_on "libusb" # RTL block
  depends_on "uhd" => :optional
  
  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install" # if this fails, try separate make/make install steps
  end
end
