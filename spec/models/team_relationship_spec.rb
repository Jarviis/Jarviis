require 'spec_helper'

describe TeamRelationship do
  it { should belong_to(:user) }
  it { should belong_to(:team) }
end
