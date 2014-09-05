require "formula"

class Cppzmq < Formula
  depends_on 'zeromq'
  homepage "http://zeromq.org/bindings:cpp"
  version "a819813"
  url "https://raw.githubusercontent.com/zeromq/cppzmq/96e05769d2db64a8ab4fb6b341b2551ff545cbdb/zmq.hpp"
  sha1 "c9d69f8c657047cdc2b4b891924398e6a4b7969d"
  
  head do
    url "https://raw.githubusercontent.com/zeromq/cppzmq/master/zmq.hpp"
  end

  def install
    include.install "zmq.hpp"
  end

end
