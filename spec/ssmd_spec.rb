require "spec_helper"
require "spec_parser"

RSpec.describe SSMD do
  let(:spec) { SpecParser.parse "SPECIFICATION.md" }

  def find_case(title)
    spec_case = spec.cases.find { |sc| sc.title == title }

    expect(spec_case).not_to be_nil, "expected specification to include '#{title}' case"

    spec_case
  end

  it "has a version number" do
    expect(SSMD::VERSION).not_to be nil
  end

  it "has 11 specs" do
    expect(spec.cases.size).to eq 11
  end

  it "converts Emphasis" do
    spec = find_case "Emphasis"
    result = SSMD.to_ssml spec.input

    expect(result).to eq spec.output
  end
end
