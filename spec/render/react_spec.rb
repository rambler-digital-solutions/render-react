require 'spec_helper'

describe Render::React do
  subject { Class.new.extend(Render::React) }

  it 'renders something' do
    expect(subject.react('test', foo: :bar)).to eq("test([{:foo=>:bar}])")
  end
end
