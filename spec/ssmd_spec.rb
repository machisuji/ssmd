require "spec_helper"
require "spec_parser"

RSpec.describe SSMD do
  let(:spec) { SpecParser.parse "SPECIFICATION.md" }

  def find_case(title)
    spec_case = spec.cases.find { |sc| sc.title == title }

    expect(spec_case).not_to be_nil, "expected specification to include '#{title}' case"

    spec_case
  end

  def check_case(title)
    spec = find_case title
    result = SSMD.to_ssml(spec.input).gsub(/\A<speak>/, "").gsub(/<\/speak>\Z/, "")

    expect(result).to eq spec.output
  end

  it "has a version number" do
    expect(SSMD::VERSION).not_to be nil
  end

  it "has 12 specs" do
    expect(spec.cases.size).to eq 12
  end

  it "converts Text" do
    spec = find_case "Text"
    result = SSMD.to_ssml spec.input

    expect(result).to eq spec.output
  end

  it "converts Emphasis" do
    check_case "Emphasis"
  end

  it "converts Language" do
    check_case "Language"
  end

  it "converts Mark" do
    check_case "Mark"
  end

  it "converts Phoneme" do
    check_case "Phoneme"
  end

  it "converts nested formats and ignores duplicate annotations" do
    check_case "Nesting and duplicate annotations"
  end
end
