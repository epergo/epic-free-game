RSpec.describe(EpicAdapter) do
  context "with invalid URL" do
    it "raises an ArgumentError" do
      expect { EpicAdapter.new("") }.to raise_error(ArgumentError)
    end
  end
end
