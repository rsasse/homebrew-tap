class Maude < Formula
  desc "reflective language for equational and rewriting logic specification"
  homepage "http://maude.cs.illinois.edu"
  url "http://maude.cs.illinois.edu/w/images/d/d8/Maude-2.7.1.tar.gz"
  sha256 "b1887c7fa75e85a1526467727242f77b5ec7cd6a5dfa4ceb686b6f545bb1534b"
  revision 1

  bottle do
    root_url "https://dl.bintray.com/tamarin-prover-org/tamarin-prover/maude"
    cellar :any
    rebuild 2
    sha256 "747d2709c2e8db7b5aaca5b0ca8e200a596052606a31bb970b3823524a98e2b5" => :high_sierra
    sha256 "952d23e1f143bfb62e21fb4b0e1b440dcfc431cc7250f458c4c1ecf7234fea5e" => :sierra
    sha256 "042a617f84cacfdd0d8f441fcf1209fe6bef76483b0cf848bded5dc378f82bc6" => :el_capitan
    sha256 "8bb72b9a8f9097656ffb4f70f7b7addb2ba2a888134af1bd96b488340d25aadc" => :yosemite
    sha256 "e341985f51abe73a4516690daf2b5bf384286b2f48414b79108cc9933187e014" => :x86_64_linux
  end

  depends_on "gmp"
  depends_on "libbuddy"
  depends_on "libsigsegv"
  depends_on "libtecla"
  depends_on "flex" unless OS.mac?
  depends_on "bison" unless OS.mac?

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{libexec}",
                          "--without-cvc4"
    system "make", "install"
    (bin/"maude").write_env_script libexec/"bin/maude", :MAUDE_LIB => libexec/"share"
  end

  test do
    input = <<~EOS
      set show stats off .
      set show timing off .
      set show command off .
      reduce in STRING : "hello" + " " + "world" .
    EOS
    expect = %Q(Maude> result String: "hello world"\nMaude> Bye.\n)
    output = pipe_output("#{bin/"maude"} -no-banner", input)
    assert_equal expect, output
  end
end
