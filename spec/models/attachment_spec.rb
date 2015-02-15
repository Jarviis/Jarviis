require 'spec_helper'

describe Attachment do
  it { should belong_to(:issue) }

  let(:user) { FactoryGirl.create(:user) }
  let(:issue) { FactoryGirl.create(:issue, reporter: user) }

  describe "#versions" do
    context "when the file is an image" do
      let(:attachment) do
        FactoryGirl.create(:attachment,
                          issue: issue,
                          filename: File.open(Rails.root.join("spec/fixtures/Lenna.png"))
                          )
      end

      it "returns the versions of the image" do
        expect(attachment.versions).to eq([:thumbnail])
      end
    end

    context "when the file is not an image" do
      let(:attachment) do
        FactoryGirl.create(:attachment,
                          issue: issue,
                          filename: File.open(Rails.root.join("app/models/issue.rb"))
                          )
      end

      it "returns an empty array" do
        expect(attachment.versions).to eq([])
      end
    end
  end

  describe "#image?" do
    context "when the file is an image" do
      let(:attachment) do
        FactoryGirl.create(:attachment,
                          issue: issue,
                          filename: File.open(Rails.root.join("spec/fixtures/Lenna.png"))
                          )
      end

      it "returns true" do
        expect(attachment.image?).to be_true
      end
    end

    context "when the file is not an image" do
      let(:attachment) do
        FactoryGirl.create(:attachment,
                          issue: issue,
                          filename: File.open(Rails.root.join("app/models/issue.rb"))
                          )
      end

      it "returns false" do
        expect(attachment.image?).to be_false
      end
    end
  end

  describe "#url" do
    context "when the file is an image" do
      let(:attachment) do
        FactoryGirl.create(:attachment,
                          issue: issue,
                          filename: File.open(Rails.root.join("spec/fixtures/Lenna.png"))
                          )
      end

      it "returns the versions of the image" do
        expect(attachment.url.keys).to match_array([:main, :thumbnail])
      end
    end

    context "when the file is not an image" do
      let(:attachment) do
        FactoryGirl.create(:attachment,
                          issue: issue,
                          filename: File.open(Rails.root.join("app/models/issue.rb"))
                          )
      end

      it "returns only main" do
        expect(attachment.url.keys).to match_array([:main])
      end
    end
  end
end
