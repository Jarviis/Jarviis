# encoding: utf-8

require 'carrierwave/test/matchers'
require 'spec_helper'

describe AttachmentUploader do
  include CarrierWave::Test::Matchers

  let(:user) { FactoryGirl.create(:user) }
  let!(:issue) { FactoryGirl.create(:issue, reporter: user) }
  let!(:attachment) { FactoryGirl.create(:attachment) }

  before do
    AttachmentUploader.enable_processing = true
    @uploader = AttachmentUploader.new
    attachment.stub(:issue_id).and_return(1)
    @uploader.stub(:model).and_return(attachment)
    @img_png = File.open(Rails.root.join("spec/fixtures/Lenna.png"))
    @text = File.open(Rails.root.join("spec/fixtures/test.txt"))
  end

  describe "versions" do
    context "when the file is an image" do
      before do
        @uploader.store!(@img_png)
      end

      it "has thumbnail version" do
        expect(@uploader.versions.keys).to match_array([:thumbnail])
      end

      context "thumbnail version" do
        it "is no larger than 200x200 pixels" do
          expect(@uploader.thumbnail).to be_no_larger_than(200, 200)
        end
      end
    end

    context "when the file is not an image" do
      before do
        @uploader.store!(@text)

        it "has no versions" do
          expect(@uploader.versions.keys).to eq []
        end
      end
    end
  end
end
