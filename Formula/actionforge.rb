class Actionforge < Formula
  desc "One-click self-hosted GitHub Actions CI runners"
  homepage "https://github.com/FlutterPlaza/actionforge"
  url "https://github.com/FlutterPlaza/actionforge/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "1d2439a2c351335f8843a2196c1a11bf82d52db3017389f12029dce72af93240"
  license "BSD-3-Clause"

  depends_on "jq"

  def install
    libexec.install "setup.sh", "Dockerfile", "docker-compose.yml", "entrypoint.sh", "autoscale.sh"
    chmod 0755, libexec/"setup.sh"
    chmod 0755, libexec/"entrypoint.sh"
    chmod 0755, libexec/"autoscale.sh"

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
