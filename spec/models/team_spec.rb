require 'spec_helper'

describe Team do
  it { should have_many(:team_relationships) }
  it { should have_many(:users).through(:team_relationships) }
end
