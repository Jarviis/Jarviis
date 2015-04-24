require 'spec_helper'

describe Search::QuerySanitizer do
  let(:string) { "I am ~~~ | String OR something and Nothing" }

  describe "sanitize" do
    it "calls replace_reserved_keywords" do
      Search::QuerySanitizer.should_receive(:replace_reserved_keywords)

      Search::QuerySanitizer.sanitize(string)
    end

    it "calls replace_punctuation" do
      Search::QuerySanitizer.should_receive(:replace_punctuation)

      Search::QuerySanitizer.sanitize(string)
    end

    it "calls String#squish" do
      String.any_instance.should_receive(:squish)

      Search::QuerySanitizer.sanitize(string)
    end
  end

  describe "replace_punctuation" do
    it "does not contain any glued punctuation characters" do
      expect(Search::QuerySanitizer.replace_punctuation(string)).not_to match(/~/)
    end

    it "does not contain any individual punctuation characters" do
      expect(Search::QuerySanitizer.replace_punctuation(string)).not_to match(/\|/)
    end
  end

  describe "replace_reserved_keywords" do
    it "does not contain any individual reserved keyword" do
      expect(Search::QuerySanitizer.replace_reserved_keywords(string)).not_to match(/and|or/i)
    end
  end
end
