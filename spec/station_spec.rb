require 'station'

describe Station do

  subject {described_class.new("Aldgate East", 1)}

  it "returns 'Aldgate East' when name is called" do
    expect(subject.name).to eq("Aldgate East")
  end

  it "returns 1 when zone is called" do
    expect(subject.zone).to eq(1)
  end
end