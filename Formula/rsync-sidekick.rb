class RsyncSidekick < Formula
  desc "Propagate file renames, moves, and timestamp changes before rsync"
  homepage "https://github.com/m-manu/rsync-sidekick"
  url "https://github.com/m-manu/rsync-sidekick/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "fefdb5d11e979c7186745dc8fd1b7bed3bb84500eec3f25c6a3484500a6d7759"
  license "Apache-2.0"
  head "https://github.com/m-manu/rsync-sidekick.git", branch: "main"

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    src = testpath/"src"
    dst = testpath/"dst"
    src.mkpath
    dst.mkpath

    (src/"vacation.jpg").write "photo-bytes"
    (dst/"holiday.jpg").write "photo-bytes"

    output = shell_output("#{bin}/rsync-sidekick --dry-run #{src} #{dst}")
    assert_match "dry run", output, ignore_case: true
    assert_match "holiday.jpg", output

    list = shell_output("#{bin}/rsync-sidekick --list #{src} #{dst}")
    assert_match "vacation.jpg", list
  end
end
