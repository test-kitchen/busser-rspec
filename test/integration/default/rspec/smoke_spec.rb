require "spec_helper"

# Runs on the machine under test through busser-rspec.
describe "the rspec runner" do
  it "reached the machine under test" do
    expect(File).to exist(Dir.tmpdir)
  end

  it "loaded spec_helper without a relative path" do
    expect(defined?(BUSSER_RSPEC_SMOKE)).to eq("constant")
  end
end
