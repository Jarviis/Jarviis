require "spec_helper"

describe Search::Manager do
  before do
    Issue.__elasticsearch__.create_index!(index: Issue.index_name)
  end

  after do
    User.__elasticsearch__.client.indices.delete(index: Issue.index_name)
  end

  subject { Search::Manager.new("Jarviis!~~", "Issue", "and", {}) }

  let(:reporter) { FactoryGirl.create(:user) }

  describe "#global_search" do
    it "performs global search on the given class" do
      Issue.should_receive(:global_search).with("Jarviis", "and", {}).
        and_call_original

      subject.global_search
    end
  end

  describe "#ids" do
    let!(:issue) { FactoryGirl.create(:issue, name: "Jarviis", reporter: reporter) }

    before do
      Issue.__elasticsearch__.import
      Issue.__elasticsearch__.refresh_index!
    end

    it "returns the ids of the matching documents" do
      subject.global_search

      expect(subject.ids).to eq([issue.id])
    end
  end

  describe "#empty?" do
    let!(:issue) { FactoryGirl.create(:issue, name: "Jarviis", reporter: reporter) }

    before do
      Issue.__elasticsearch__.import
      Issue.__elasticsearch__.refresh_index!
    end

    context "when the results are not empty" do
      it "returns false" do
        subject.global_search

        expect(subject.empty?).to be_false
      end
    end

    context "when the results are empty" do
      subject { Search::Manager.new("KilimiaXalia", "Issue", "and", {}) }

      it "returns true" do
        subject.global_search

        expect(subject.empty?).to be_true
      end
    end
  end
end
