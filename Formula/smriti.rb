# typed: false
# frozen_string_literal: true

# Homebrew formula for Smriti — local screen memory with Claude as the brain.
# Tap:  brew tap rockykusuma/smriti
# Install: brew install rockykusuma/smriti/smriti
class Smriti < Formula
  desc "Local screen memory for macOS with Claude as the brain"
  homepage "https://github.com/rockykusuma/smriti"
  url "https://github.com/rockykusuma/smriti/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "ff138dae558f1d715995ca9a04a08346b227d73e931af3986705464cf3031947"
  license "MIT"
  head "https://github.com/rockykusuma/smriti.git", branch: "main"

  depends_on xcode: ["14.0", :build]
  depends_on macos: :ventura # AppKit/ScreenCaptureKit APIs; macOS 13+

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/smriti"
  end

  def caveats
    <<~EOS
      Smriti captures the frontmost window's text via the Accessibility API,
      so on first run grant it Accessibility in System Settings > Privacy &
      Security. Reply assist also needs Input Monitoring; meeting recording
      needs Microphone, Screen Recording and Speech Recognition.

      Because Homebrew installs an ad-hoc-signed binary, re-grant Accessibility
      after each upgrade (remove and re-add /opt/homebrew/bin/smriti), or sign
      with a stable identity as described in the README.

      Start capturing:      smriti capture
      Run at login (menu):  smriti install-agent menubar
      Register the MCP server with Claude Desktop — see the README.
    EOS
  end

  test do
    # stats runs against an empty store under the sandboxed HOME and exits 0.
    system bin/"smriti", "stats"
  end
end
