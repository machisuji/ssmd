require "spec_helper"
require "spec_parser"

RSpec.describe SSMD do
  let(:spec) { SpecParser.parse "SPECIFICATION.md" }

  def find_case(title)
    spec_case = spec.cases.find { |sc| sc.title == title }

    expect(spec_case).not_to be_nil, "expected specification to include '#{title}' case"

    spec_case
  end

  def check_case(title, skip: [])
    spec = find_case title
    result = SSMD.to_ssml(spec.input, skip: skip).gsub(/\A<speak>/, "").gsub(/<\/speak>\Z/, "")

    expect(result).to eq spec.output
  end

  describe ".to_ssml" do
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

    it "converts Break" do
      check_case "Break"
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

    it "converts Prosoddy" do
      # don't generate paragraphs in this spec to make the
      # resulting SSML for the spec more readable
      check_case "Prosody", skip: :paragraph
    end

    it "converts Paragraph" do
      check_case "Paragraph"
    end

    it "converts Substitution" do
      check_case "Substitution"
    end

    it "converts nested formats and ignores duplicate annotations" do
      check_case "Nesting and duplicate annotations"
    end

    context "with skip" do
      it ":prosody it skips Prosody" do
        input = "some [text](vrp: 555) with >>prosody>>"

        expect(SSMD.to_ssml(input, skip: :prosody)).to eq "<speak>some [text](vrp: 555) with &gt;&gt;prosody&gt;&gt;</speak>"
      end

      it ":emphasis it skips Emphasis" do
        input = "some *text* with *Emphasis*"

        expect(SSMD.to_ssml(input, skip: :emphasis)).to eq "<speak>#{input}</speak>"
      end
    end

    context "with more complex examples" do
      it "supports nested Prosody" do
        input = "[one [two](p: 5) three](p: 1)"

        expect(SSMD.to_ssml(input)).to eq "<speak><prosody pitch=\"x-low\">one <prosody pitch=\"x-high\">two</prosody> three</prosody></speak>"
      end
    end

    describe "edge cases" do
      describe "Break" do
        it "should work with breaks at the beginning and end of inputs" do
          input = "... hallo ..."
          expected = "<speak><break strength=\"x-strong\"/> hallo <break strength=\"x-strong\"/></speak>"

          expect(SSMD.to_ssml(input)).to eq expected
        end
      end
    end
  end

  describe ".strip_ssmd" do
    let(:cases) do
      {
        "Hallo *welt* [A *B* C](en)" => "Hallo welt A B C",
        "<*dear* lord<" => "dear lord",
        "Some ...c text" => "Some text",
        "... Hello ...2s World ...2s" => "Hello World"
      }
    end

    it "returns the plain text without SSMD annotations" do
      cases.each do |input, output|
        expect(SSMD.strip_ssmd(input)).to eq output
      end
    end

    context "with skip" do
      it ":prosody it skips prosody" do
        input = "some [text](vrp: 555) with >>prosody>>"

        expect(SSMD.strip_ssmd(input, skip: :prosody)).to eq input
      end

      it ":emphasis it skips Emphasis" do
        input = "some *text* with *Emphasis*"

        expect(SSMD.strip_ssmd(input, skip: :emphasis)).to eq input
      end
    end
  end
end
