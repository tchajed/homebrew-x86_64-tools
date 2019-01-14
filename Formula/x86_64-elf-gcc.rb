class X8664ElfGcc < Formula
  desc "The GNU compiler collection for x86_64-elf"
  homepage "https://gcc.gnu.org"
  url "https://mirrors.nju.edu.cn/gnu/gcc/gcc-8.2.0/gcc-8.2.0.tar.xz"
  sha256 "196c3c04ba2613f893283977e6011b2345d1cd1af9abeac58e916b1aab3e0080"

  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "x86_64-elf-binutils"

  def install
    mkdir "x86_64-elf-gcc-build" do
      system "../configure", "--target=x86_64-elf",
                             "--prefix=#{prefix}",
                             "--without-isl",
                             "--disable-multilib",
                             "--disable-nls",
                             "--disable-werror",
                             "--without-headers",
                             "--with-as=#{Formula["x86_64-elf-binutils"].bin}/x86_64-elf-as",
                             "--with-ld=#{Formula["x86_64-elf-binutils"].bin}/x86_64-elf-ld",
                             "--enable-languages=c,c++"
      system "make", "all-gcc"
      system "make", "install-gcc"
      system "make", "all-target-libgcc"
      system "make", "install-target-libgcc"
    end
  end

  test do
    (testpath/"test-c.c").write <<~EOS
      int main(void)
      {
        int i=0;
        while(i<10) i++;
        return i;
      }
    EOS
    system "#{bin}/x86_64-elf-gcc", "-c", "-o", "test-c.o", "test-c.c"
    assert_match "file format elf32-x86_64", shell_output("#{Formula["x86_64-elf-binutils"].bin}/x86_64-elf-objdump -a test-c.o")
  end
end
