require "rake/rdoctask"
require "rake/testtask"
require "rake/gempackagetask"
require "rake/contrib/rubyforgepublisher"
require "net/ssh"

require "rubygems"
require "rubyforge"

dir = File.dirname(__FILE__)
lib = File.join(dir, "lib", "nuvoli", "agent.rb")
version = File.read(lib)[/^\s*VERSION\s*=\s*(['"])(\d\.\d\.\d)\1/, 2]
history = File.read("CHANGELOG").split(/^(===.*)/)
changes ||= history[0..2].join.strip

need_tar = true
need_zip = true

task :default => [:test]

# Rake::TestTask.new do |test|
#   test.libs << "test"
#   test.test_files = [ "test/agent_test.rb" ]
#   test.verbose = true
# end

Rake::RDocTask.new do |rdoc|
  rdoc.main = "README"
  rdoc.rdoc_dir = "doc/html"
  rdoc.title = "Nuvoli Agent Documentation"
  rdoc.rdoc_files.include( "README",  "INSTALL",
                           "TODO",    "CHANGELOG",
                           "AUTHORS", "lib/" )
end

spec = Gem::Specification.new do |spec|
  spec.name = "nuvoli-agent"
  spec.version = version

  spec.platform = Gem::Platform::RUBY
  spec.summary = "The Nuvoli agent configures a node and reports its status to a Nuvoli server."

  # TODO: test suite
  # spec.test_suite_file = "test/ts_all.rb"
  spec.files = Dir.glob("{bin,lib}/**/*.rb") + %w[Rakefile]
  spec.executables = ["nuvoli-agent"]

  spec.has_rdoc = true
  spec.extra_rdoc_files = %w[ AUTHORS README INSTALL TODO CHANGELOG ]
  spec.rdoc_options << "--title" << "Nuvoli Agent Documentation" << "--main" << "README"

  spec.require_path = "lib"

  spec.add_dependency "excon"
  spec.add_dependency "ohai"
  spec.add_dependency "mixlib-config"

  spec.author = "Nuvoli"
  spec.email = "support@nuvo.li"
  # spec.rubyforge_project = "nuvoli"
  spec.homepage = "http://nuvo.li"
  spec.description = <<END_DESC
The Nuvoli agent configures a node and reports its status to a Nuvoli server.
END_DESC
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = need_tar
  pkg.need_tar = need_zip
end

# desc "Publishes to Agent Gem Server and Rubyforge"
# task :publish => [:package, :publish_rubyforge]
# 
# desc "Publishes Gem to Rubyforge"
# task :publish_rubyforge => [:package] do
#   puts "Publishing on RubyForge"
#   forge = RubyForge.new
#   forge.configure
#   puts "Logging in"
#   forge.login
# 
#   release = forge.userconfig
#   release["release_changes"] = File.read(File.join(dir, "CHANGELOG"))
#   release["preformatted"] = true
# 
#   package = "pkg/#{spec.name}-#{version}"
#   files = %W[#{package}.tgz #{package}.zip #{package}.gem].compact
# 
#   puts "Releasing #{spec.name}-#{version}"
#   forge.add_release(spec.rubyforge_project, spec.name, version, *files)
# end
