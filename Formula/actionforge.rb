class Actionforge < Formula
  desc "One-click self-hosted GitHub Actions CI runners"
  homepage "https://github.com/FlutterPlaza/actionforge"
  url "https://github.com/FlutterPlaza/actionforge/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "2fd8db573fb63986ae84a472e3ff4461d8c7546543515bcf2158901cc8c0aacb"
  license "BSD-3-Clause"

  depends_on "jq"

  def install
    libexec.install "setup.sh", "Dockerfile", "docker-compose.yml", "entrypoint.sh"
    chmod 0755, libexec/"setup.sh"
    chmod 0755, libexec/"entrypoint.sh"

    (bin/"actionforge").write <<~SH
      #!/usr/bin/env bash
      exec "#{libexec}/setup.sh" "$@"
    SH
  end

  def caveats
    <<~EOS
      ActionForge requires Docker to run in Docker mode (recommended).
      Install Docker Desktop if you haven't already:

        brew install --cask docker

      To get started:

        actionforge

      Docker files are copied to ~/.actionforge/ at runtime so they
      survive Homebrew upgrades. To remove everything:

        actionforge --teardown
    EOS
  end

  test do
    assert_match "ActionForge", shell_output("#{bin}/actionforge --version")
  end
end
